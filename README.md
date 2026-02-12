# AutoDev Cloud Platform Architecture

This document explains the architecture of our AutoDev Cloud Platform, showing how traffic flows from external clients to internal services running inside an EKS cluster. The diagram and explanation highlight each component, its role, and why it's needed.

![Architecture Flow](./A_flowchart_diagram_illustrates_the_architecture_o.png)

---

## Architecture Flow Overview

The flow follows this path:

**Client → API Gateway → Cognito → VPC Link → NLB → Worker Node → Ingress Controller → Services**

This design ensures security, scalability, and proper routing inside the cluster.

---

## Components Description

### 1. Client
- **Type:** Web / Mobile
- **Role:** Sends HTTP requests to the platform.
- **Reason:** Entry point for users or external systems.

---

### 2. API Gateway (HTTP API)
- **Type:** AWS API Gateway (HTTP API)
- **Features:** 
  - JWT Authentication integrated with **Cognito**.
  - Serves as the single entry point to all services.
- **Reason:** 
  - Centralizes access control.
  - Handles authentication/authorization.
  - Forwards traffic to backend services securely.

---

### 3. Cognito (JWT Auth)
- **Type:** AWS Cognito User Pool
- **Role:** Validates user identity via JWT tokens.
- **Reason:** 
  - Ensures only authorized users access the API.
  - Supports secure authentication flow without hardcoding credentials.

---

### 4. VPC Link
- **Type:** API Gateway VPC Link
- **Role:** Connects the API Gateway to **internal resources** in the private VPC.
- **Reason:** 
  - Enables API Gateway (public) to communicate with private NLB inside VPC.
  - Maintains security by avoiding direct public exposure of internal services.

---

### 5. NLB (Network Load Balancer)
- **Type:** AWS Network Load Balancer
- **Port:** 30080
- **Role:** Distributes incoming traffic from VPC Link to worker nodes.
- **Reason:** 
  - High availability and scalability.
  - Handles TCP routing efficiently inside private subnet.

---

### 6. Worker Node
- **Type:** EC2 instances (Node Group)
- **Role:** Hosts pods running application services.
- **Node Role:** Provides permissions to pull Docker images from ECR and interact with the cluster.
- **Reason:** 
  - Executes the workloads.
  - Ensures pods have access to necessary AWS resources without over-permissioning.

---

### 7. Ingress Controller
- **Type:** Nginx / Kubernetes Ingress Controller
- **Role:** Routes incoming traffic from worker nodes to specific services inside the cluster based on Host/Path.
- **Reason:** 
  - Provides internal routing and service discovery.
  - Decouples external access from internal service structure.
  - Enables using a single port and host while routing multiple applications.

---

## IAM Roles Overview

IAM roles provide fine-grained access control for each part of the system:

| Role | Used By | Purpose |
|------|---------|---------|
| **Cluster Role** | EKS Control Plane | Allows the control plane to manage AWS resources like Load Balancers, Security Groups, ENIs, etc. |
| **Node Role** | Worker Nodes (EC2) | Lets nodes join the cluster, pull images from ECR, and manage networking for pods. |
| **IRSA Role** | Specific Pods | Provides pods only the permissions they need using Kubernetes ServiceAccount + OIDC federation. |
| **SSM Read Role** | Pods (via IRSA) | Allows pods to securely read secrets from AWS Systems Manager Parameter Store (e.g., DB credentials) without hardcoding them. |

---

## Port Exposure Concept

- **API Gateway:** Exposed publicly to clients.
- **VPC Link → NLB → Worker Node:** Traffic flows through private ports (e.g., 30080), not publicly exposed.
- **Ingress Controller:** Handles routing to services internally, allowing multiple apps to share the same external endpoint securely.
- **Security:** Only the API Gateway is exposed to the internet; all other components stay private, enforcing the principle of least privilege.

---

## Summary

This architecture provides:

- **Secure public access** via API Gateway + Cognito.
- **Private routing** of traffic through VPC Link and NLB.
- **Scalable deployment** with worker nodes and Ingress routing.
- **Fine-grained access control** using Node Roles and IRSA for pods.
- **Multiple apps routing** handled cleanly by Ingress Controller without changing API Gateway.
