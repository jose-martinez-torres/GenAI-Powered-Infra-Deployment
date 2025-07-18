# Terraform GCP Infrastructure Repository

This repository contains Terraform scripts for managing and provisioning infrastructure on Google Cloud Platform (GCP).

## Overview

The Terraform configurations within this repository are designed to [**Briefly describe the purpose of the infrastructure, e.g., "deploy a multi-service application on Google Kubernetes Engine (GKE)," or "manage our organization's shared VPC and IAM resources in GCP."**].

Our goal is to codify our GCP infrastructure, enabling version control, collaboration, and automated deployments.

## Prerequisites

Before you can apply these Terraform configurations, ensure you have the following prerequisites installed and configured:

*   **Terraform**: [Specify version, e.g., v1.0.0 or higher]. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
*   **Google Cloud SDK (gcloud CLI)**: Authenticated and configured with appropriate permissions for your GCP project. You can install it from the [Google Cloud SDK documentation](https://cloud.google.com/sdk/docs/install).
    *   Ensure you've run `gcloud auth application-default login` or have service account credentials configured for Terraform.
    *   Set your default project: `gcloud config set project YOUR_PROJECT_ID`
*   **[Any other specific tools or dependencies]**: e.g., `jq`, `make`, a specific version of Python, etc.

## Directory Structure (Optional - Recommended for larger projects)

A brief overview of how the repository is organized:

Contains the Terraform Script required to create a pub/sub which is the test to create the initial version of the CI/CD pipeline.

