# 3-tier-app-deployment-AOTOMATION


This project automates the deployment of a 3-tier web application using Terraform, Ansible, Docker, and Azure DevOps. It includes infrastructure provisioning, application containerization, and CI/CD pipelines.

![image](https://github.com/user-attachments/assets/b09ba903-ba4e-4f11-8eba-d37f1802a91b)

## 🛠️ Technologies Used

- **Terraform** – for provisioning Azure resources (VMs, NSGs, etc.)
- **Ansible** – for remote configuration and deployment of frontend/backend
- **Docker & Docker Hub** – for containerizing frontend and backend apps
- **Azure DevOps Pipelines** – for CI/CD automation
- **Azure SQL Database** – for persistent backend storage

---

## 🔧 What it Deploys

- A 3-tier architecture:
  - **Frontend**: Next.js app (Dockerized)
  - **Backend**: Express.js API (Dockerized)
  - **Database**: Azure SQL DB
- **High Availability**:
  - Multiple VMs for frontend and backend
  - Load Balancer for traffic distribution
  - App gateway
