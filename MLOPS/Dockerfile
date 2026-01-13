# Stage 1: Build Stage (for installing dependencies)
# Use a lightweight official Python image with development tools
FROM python:3.10-slim AS builder

# Set environment variables for non-interactive commands
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory
WORKDIR /app

# Install system dependencies needed for some Python packages (e.g., pandas, numpy)
# In a real-world scenario, you might need more specific packages,
# but this is a good starting point.
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy only the requirements file first to take advantage of Docker's layer caching
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Production/Runtime Stage
# Use a very minimal Python image for the final deployment
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Copy the installed packages from the 'builder' stage to the final image
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

# Copy the source code (your model and application logic)
# This assumes your main Python code is in the 'src/' directory as per your file structure.
COPY src/ /app/src/
COPY requirements.txt /app/

# Expose the port your model serving application will run on (e.g., if using FastAPI/Flask)
# You may need to change this port based on your application.
EXPOSE 8080

# Define environment variables (e.g., for model loading)
# Example: ENV MODEL_PATH /app/src/model.pkl

# Specify the command to run the application when the container starts
# Replace 'src.server:app' with the actual path to your application's entry point.
# This assumes a model serving framework like Uvicorn/Gunicorn running an app.
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "src.api.server:app"] 
# Example: CMD ["python", "src/main.py"] if it's a simple script