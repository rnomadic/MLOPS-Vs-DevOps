# MLOps & LLMOps Engineering Excellence

This repository serves as a comprehensive technical guide and implementation framework for MLOps (Machine Learning Operations).


---

## 💻 CI/CD: DevOps vs. MLOps

MLOps introduces a "Third Pillar" to traditional CI/CD: **Continuous Training (CT)**. Unlike standard software, ML performance depends on code, data, and the model artifact.

| Feature | Traditional DevOps | MLOps |
| :--- | :--- | :--- |
| **Core Artifact** | Code & Configuration | Code, Data, & Model |
| **Triggers** | Git Commits | Code changes, Data changes, Performance decay |
| **Testing** | Unit & Integration tests | Data validation, Model quality, Bias detection |
| **Version Control** | Code versioning (Git) | Versioning for Code (Git), Data (DVC/Feature Stores), and Models (Model Registry, e.g., MLflow) |

---

## 🚀 The MLOps CI/CD is multi-trigger
Code change: CI -> CT ->CD: 
Data Change: CT -> CD: New data arrives (e.g., a nightly job aggregates new customer data).
Model Degradation: CT -> CD: 


### CI – The Core Trigger Mechanism: The Git Webhook
When a developer (or data scientist) pushes new code to the central repository (e.g., a git push to the main or a feature branch), the following happens:
1.	The Event: The version control system (like GitHub, GitLab, or Azure DevOps) detects the new commit/merge.
2.	The Notification (Webhook): The system immediately sends an automated message, called a webhook, to the central CI/CD orchestrator (e.g. GitHub Actions, Jenkins, or Kubeflow).
3.	The Activation: The orchestrator receives the signal and initiates the first stage of the pipeline (Continuous Integration).

Please check MLOPS\CI-workflow.yml.
This CI workflow is now ready to be saved inside the. github/workflows/ directory of your GitHub repository. 

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]


### Zero-Downtime Strategies with Helm
Using **Helm Charts** allows for version-controlled deployments. For zero-downtime on AKS/GKE:
- **Blue/Green Deployment:** Run the new model (Green) alongside the old (Blue). Switch traffic only after Green passes health checks.
- **Canary Deployment:** Route 5-10% of traffic to the new model to monitor for errors before a full rollout.

---

## 🛠 Infrastructure as Code (Terraform)
We use Terraform to ensure environment parity across Staging and Production.
- **State Management:** Remote state locking is implemented via Azure Blob Storage/S3 to prevent race conditions.
- **Provisioned Resources:** Azure ML Workspace, AKS Clusters, and Key Vault for secret management.

---

## 📈 Experiment Tracking with MLflow
To ensure 100% reproducibility, we utilize the four pillars of MLflow:
1. **Tracking:** Logs parameters, metrics, and code versions.
2. **Projects:** Standardized packaging (Conda/Docker).
3. **Models:** Unified format for various downstream tools.
4. **Registry:** Centralized hub for model versioning and stage transitions (Staging -> Production).

---

## 🕵️ Case Study: Real-Time Fraud Detection
The system is designed for sub-100ms latency using a microservices architecture.
- **Inference Service:** A Python/FastAPI service optimized for throughput.
- **Feature Store:** Redis/Hopsworks for low-latency retrieval of user transaction history.
- **Troubleshooting:** If performance drops, we analyze for **Covariate Drift** (input distribution changes) or **Concept Drift** (the definition of fraud has evolved).

---

## 🤖 The LLMOps Pipeline
LLMOps extends MLOps to handle the unique challenges of non-deterministic models.



### Evaluation & Guardrails
- **LLM-as-a-Judge:** Using frameworks like **Ragas** or **DeepEval** to have a strong model (e.g., GPT-4) grade a smaller model (e.g., Llama-3).
- **Metrics:** Faithfulness, Relevance, and Tone.
- **Guardrails:** Implementation of **NVIDIA NeMo Guardrails** to prevent PII leakage and toxicity.

### Recommended Stack
| Component | Tools |
| :--- | :--- |
| **Orchestration** | LangChain, LlamaIndex |
| **Vector DB** | Pinecone, Milvus, ChromaDB |
| **Serving** | vLLM, TGI, Ollama |
| **Monitoring** | Arize Phoenix, Weights & Biases |

---
