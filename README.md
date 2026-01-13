# This Repo Is all about MLOPS Engineering

<span style="color: red;"> This Repo Is all about MLOPS Engineering </span>

## 1. What are the differences between CI/CD for traditional software versus CI/CD for an ML model? </span>
### The MLOps CI/CD is multi-trigger
### Code change: CI -> CT ->CD: 
### Data Change: CT -> CD: New data arrives (e.g., a nightly job aggregates new customer data).
### Model Degradation: CT -> CD: 

### CI – The Core Trigger Mechanism: The Git Webhook
When a developer (or data scientist) pushes new code to the central repository (e.g., a git push to the main or a feature branch), the following happens:
1.	The Event: The version control system (like GitHub, GitLab, or Azure DevOps) detects the new commit/merge.
2.	The Notification (Webhook): The system immediately sends an automated message, called a webhook, to the central CI/CD orchestrator (e.g. GitHub Actions, Jenkins, or Kubeflow).
3.	The Activation: The orchestrator receives the signal and initiates the first stage of the pipeline (Continuous Integration).


