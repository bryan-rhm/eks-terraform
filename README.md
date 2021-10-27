# Terraform AWS EKS

This project setups an EKS cluster with one managed node group and the following charts:
- Cluster Autoscaler
- Metrics Server
- External DNS
- Grafana
- Prometheus
- Influxdb
- fluent-bit
- AWS Load Balancer Controller

Additionally configures an OIDC provider for Github and a pipeline role to be assumed by github actions.

### Requirements:
- terraform cli installed >= 1.0.6
- aws cli v2

### Project Structure:

## 1. Remote Backend

This project is used to setup the Terraform S3 backend, it only needs to be applied once and it's going to launch the following resources:

- S3 bucket 
- Dynamodb table
- Github OIDC and Pipeline Role

Once you have deployed the project you can modify the `backend.tf` file of the projects with the correct values for the bucket and dynamodb_table

The Pipeline role will be used for your github actions in order to access our eks clusters and push ecr images.

## 2. Infrastructure

This project is used to provision all the infrastructure such as:

- VPC
- EKS
- ECR

## 3. Kubernetes Plugins

Once you have the backend configured and the infrastructure deployed you are ready to deploy following kubernetes plugins:

- Cluster Autoscaler
- Grafana
- Prometheus
- Influxdb
- fluent-bit
- Metrics Server
- External DNS
- AWS Load Balancer Controller

After you have deployed the project you will be able to connect to the cluster, execute the following command in order to configure the kube config file.

```bash
aws eks update-kubeconfig --name <CLUSTER_NAME>
```