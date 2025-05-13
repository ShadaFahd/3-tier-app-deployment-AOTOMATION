# 3-tier-app-deployment-AOTOMATION


This project automates the deployment of a 3-tier web application using Terraform, Ansible, Docker, and Azure DevOps. It includes infrastructure provisioning, application containerization, and CI/CD pipelines.

## Technologies
- Terraform
- Ansible
- Docker & Docker Hub
- Azure Virtual Machines
- Azure DevOps Pipelines


---

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
