# AutoDev Cloud Platform Architecture & Deployment

This README explains the architecture, deployment, monitoring, and CI/CD workflows for the **AutoDev Cloud Platform** running on AWS EKS.

---

## Architecture Overview

**Client → API Gateway → Cognito → VPC Link → NLB → Target Group → Worker Nodes → Ingress Controller → Ingress → Service → App**

### Architecture Flow Diagram (Watercolor Style)
<img width="597" height="854" alt="image" src="https://github.com/user-attachments/assets/f715df02-1546-460f-bc6c-43c83a4c11c0" />






The request flow starts from the browser or client, passes through AWS API Gateway with Cognito JWT authorization, then securely routes via VPC Link to the internal NLB, reaches the EKS worker nodes through the target group, gets handled by the NGINX Ingress Controller, and finally delivers to the application pod via Kubernetes Service.
<!-- Alternative high-quality diagram suggestion: -->
<!-- ![EKS with API Gateway, VPC Link, NLB and NGINX Ingress](https://miro.medium.com/1*niGSisdWs18X_XgEfc4qog.jpeg) -->

---

## Components Description

### 1. Client
- **Type:** Web / Mobile
- **Role:** Sends HTTP requests to the platform
- **Reason:** Entry point for users or external systems

### 2. API Gateway (HTTP API)
- **Type:** AWS API Gateway
- **Features:**
  - JWT Authentication via Cognito
  - Single entry point for all services
- **Reason:** Centralized access control and secure routing to backend

### 3. Cognito (JWT Auth)
- **Type:** AWS Cognito User Pool
- **Role:** Validates user identity using JWT tokens
- **Reason:** Secure authorization without hardcoded credentials

### 4. VPC Link
Connects API Gateway to the internal NLB in private subnets for enhanced security.

### 5. NLB (Network Load Balancer)
- Listens on TCP port 30080
- Distributes traffic to worker nodes inside the EKS cluster

### 6. Worker Nodes (EC2 Instances)
- Host application pods
- Node IAM role grants access to ECR, cluster resources, etc.

### 7. Ingress Controller (NGINX)
- Routes traffic from NodePort → ClusterIP Services based on host/path rules
- Allows multiple applications to share the same external endpoint

### 8. Service (ClusterIP)
- Provides internal load balancing and discovery for pods
- Decouples pod IPs from external access

### 9. Application Pod
- Runs the main app container listening on port 8080
- Scalable, isolated, and easy to deploy/rollout

**Traffic Flow Example (NLB → Ingress → Pods)**
<img width="830" height="336" alt="image" src="https://github.com/user-attachments/assets/3ef520d0-775c-4893-aa42-035d85b94232" />



<!-- Another clear option: -->
<!-- ![Ingress to Service to Pod overview](https://miro.medium.com/1*KIVa4hUVZxg-8Ncabo8pdg.png) -->

---

## IAM Roles Overview

| Role              | Used By              | Purpose                                                                 |
|-------------------|----------------------|-------------------------------------------------------------------------|
| **Cluster Role**  | EKS Control Plane    | Manage AWS resources (LBs, Security Groups, ENIs)                       |
| **Node Role**     | Worker Nodes         | Pull images from ECR, networking permissions                            |
| **IRSA Role**     | Specific Pods        | Fine-grained permissions using OIDC federation (no long-lived keys)    |
| **SSM Read Role** | Pods                 | Securely read configuration/secrets from Parameter Store               |



<!-- Alternative detailed view: -->
<!-- ![IRSA with OIDC and STS](https://miro.medium.com/v2/resize:fit:1400/1*QGunaPLP0fLmr7KYs9fN7A.png) -->

---

## Deployment & Monitoring Flow

### Deployment & Monitoring Diagram

<img width="928" height="381" alt="image" src="https://github.com/user-attachments/assets/ac037757-7e70-4d4e-96dc-3b80c32e06b2" />


### Key Components
1. **AWS NLB** – Receives external traffic (TCP 80 → NodePort 30080)
2. **Kubernetes Nodes (EC2)** – Host pods and expose NodePort
3. **Ingress Controller (NGINX)** – Routes to ClusterIP Services
4. **Application Pods** – Run containers on port 8080
5. **GitHub** – Stores Helm charts and Kubernetes manifests
6. **Argo CD** – Continuously syncs desired state from Git (GitOps)
7. **Datadog Agent Pod** – Collects metrics, logs, traces

### Flow Summary
- **Traffic:** NLB → NodePort → Ingress → ClusterIP → Pods
- **Deployment:** GitHub → Argo CD → Apply manifests → Pods
- **Monitoring:** Pods → Datadog Agent → Datadog Dashboards

**GitOps with Argo CD Workflow**

![Argo CD GitOps pull & sync diagram](https://miro.medium.com/v2/resize:fit:1400/0*xlhcKxOp0eh9RHsu)

<!-- Another good pipeline view: -->
<!-- ![GitHub Actions + Argo CD CI/CD flow](https://miro.medium.com/v2/resize:fit:1400/1*UsoRh3pKIEzO-fmOZrKcZA.png) -->

---

## CI/CD Pipelines Overview

All pipelines live in `.github/workflows`:

| Workflow File            | Purpose                                              |
|--------------------------|------------------------------------------------------|
| `ci-pipeline.yml`        | Continuous Integration (build, test, lint)           |
| `cd-pipeline.yml`        | Continuous Deployment (push Helm charts / manifests) |
| `cognito&Apitest.yml`    | Cognito user setup + API integration testing         |
| `infra-pipeline.yml`     | Terraform provisioning / updates                     |
| `monitoring.yml`         | Deploy & configure monitoring stack (Datadog)        |

> **Note:** Workflows follow GitOps best practices — declarative, version-controlled, automated.


