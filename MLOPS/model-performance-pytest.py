import pytest
import numpy as np
from sklearn.metrics import precision_score, recall_score
import os

# --- Configuration ---
# Read configuration from environment variables, providing default values if not set.
# NOTE: Environment variables are always strings, so we must cast them to float.

try:
    MIN_PRECISION = float(os.environ.get("BENCHMARK_PRECISION", 0.85))
    MIN_RECALL = float(os.environ.get("BENCHMARK_RECALL", 0.70))
    MODEL_PATH = os.environ.get("MODEL_ARTIFACT_PATH", "models/latest_model.pkl")
    VALIDATION_DATA_PATH = os.environ.get("VALIDATION_DATA_PATH", "data/validation.csv")
except ValueError:
    # Fail fast if environment variables are set but are not valid numbers
    raise EnvironmentError("CI configuration error: BENCHMARK_PRECISION or BENCHMARK_RECALL must be valid numbers.")


# --- Mock Model and Data Loading ---

def load_and_evaluate_model():
    """
    Loads the trained model and validation data using configurable paths from the environment.
    
    In a real application, this function would:
    1. Load the model from MODEL_PATH.
    2. Load the validation dataset (X_val, y_val) from VALIDATION_DATA_PATH.
    3. Generate predictions: y_pred = model.predict(X_val).
    4. Return the calculated metrics.
    
    For demonstration, we use mocked (but realistic) results.
    """
    print(f"Loading model from: {MODEL_PATH}")
    print(f"Loading validation data from: {VALIDATION_DATA_PATH}")
    
    # Mock true labels (y_true) and predicted labels (y_pred)
    # A mix of true positives, true negatives, false positives, and false negatives
    y_true = np.array([0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1])
    y_pred = np.array([0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1])
    
    # Calculate metrics
    current_precision = precision_score(y_true, y_pred)
    current_recall = recall_score(y_true, y_pred)
    
    return current_precision, current_recall

# --- Pytest Test Function ---

def test_model_benchmarks():
    """
    Tests if the model's current performance meets the required benchmark thresholds.
    This test serves as the critical gate for the CI/CD pipeline.
    """
    
    current_precision, current_recall = load_and_evaluate_model()
    
    print(f"\n--- Model Performance Results ---")
    print(f"Configured Precision: {MIN_PRECISION}")
    print(f"Configured Recall:    {MIN_RECALL}")
    print(f"Current Precision: {current_precision:.4f} (Required: >= {MIN_PRECISION})")
    print(f"Current Recall:    {current_recall:.4f} (Required: >= {MIN_RECALL})")
    print(f"---------------------------------\n")

    # CRITICAL ASSERTIONS:
    assert current_precision >= MIN_PRECISION, \
        f"Precision failure: {current_precision:.4f} is below the minimum required benchmark of {MIN_PRECISION}."

    assert current_recall >= MIN_RECALL, \
        f"Recall failure: {current_recall:.4f} is below the minimum required benchmark of {MIN_RECALL}."

# --- Example of a test that would intentionally fail for demonstration ---
@pytest.mark.xfail(reason="Intentionally demonstrates a benchmark failure.")
def test_low_performance_model():
    """
    A separate test to demonstrate what happens when performance is too low.
    Remove '@pytest.mark.xfail' to see the test fail.
    """
    # Low performance mock data
    y_true_low = np.array([0, 0, 1, 1, 0, 1])
    y_pred_low = np.array([0, 0, 0, 0, 0, 0]) # Missed 2 frauds, low recall
    
    low_recall = recall_score(y_true_low, y_pred_low)
    
    # This assertion would fail the CI check if not marked xfail
    assert low_recall >= MIN_RECALL, "Low performance test failed as expected."