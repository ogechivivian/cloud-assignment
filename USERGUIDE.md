# Project Name: Cloud Assignment

## Overview
This repository contains a .NET Core application and the necessary configurations to build, publish, and deploy it using Docker and GitHub Actions. The project is designed for deployment to an Amazon EKS (Elastic Kubernetes Service) cluster.

## Table of Contents
- [Dockerfile](#dockerfile)
    - [Build Stage](#build-stage)
    - [Runtime Stage](#runtime-stage)
- [GitHub Actions Workflow](#github-actions-workflow)
    - [Build and Push Docker Image](#build-and-push-docker-image)
    - [Deploy to EKS](#deploy-to-eks)
- [Setup](#setup)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Dockerfile

### Build Stage
The build stage uses the .NET SDK to compile and publish the application:
```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copying files to the build container
COPY . ./

# Restore nuget packages
RUN dotnet restore

# Publishing the app in Release mode to the /out folder
RUN dotnet publish -c Release -o out
```

### Runtime Stage
The runtime stage uses the .NET runtime image to run the application:
```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app

# Copying only the published output from the build stage
COPY --from=build /app/out .

# Start the application by default
ENTRYPOINT [ "dotnet", "aspnet-core-dotnet-core.dll" ]
```

## GitHub Actions Workflow
The repository includes a GitHub Actions workflow to automate building, testing, and deploying the application.

### Build and Push Docker Image
This job builds the Docker image, runs tests, and pushes the image to Docker Hub.

#### Workflow Trigger
The workflow is triggered on a push to the `main` branch:
```yaml
on:
  push:
    branches: [ main ]
```

#### Steps
1. **Checkout Code**: Fetch the repository's code.
2. **Setup .NET SDK**: Install the required .NET SDK version.
3. **Restore Dependencies**: Restore NuGet packages.
4. **Build the Project**: Compile the application in release mode.
5. **Run Tests**: Execute unit tests.
6. **Publish the Application**: Publish the application for deployment.
7. **Login to Docker Hub**: Authenticate with Docker Hub.
8. **Build and Push Docker Image**: Build and push the Docker image to Docker Hub.

### Deploy to EKS
This job deploys the application to an Amazon EKS cluster.

#### Steps
1. **Configure AWS Credentials**: Set up AWS credentials for authentication.
2. **Install `kubectl`**: Install the Kubernetes CLI tool.
3. **Update `kubeconfig`**: Configure access to the EKS cluster.
4. **Apply Kubernetes Manifests**: Deploy the application and its service to EKS.
5. **Update Image**: Update the deployment's container image.
6. **Rollout Deployment**: Verify and monitor the deployment rollout.
7. **Apply Horizontal Pod Autoscaler**: Apply HPA configurations for scaling.

## Setup
### Prerequisites
- Docker
- .NET SDK (7.0 or later)
- Kubernetes CLI (`kubectl`)
- AWS CLI configured with access to your EKS cluster

### Secrets
Ensure the following secrets are configured in your GitHub repository:
- `DOCKER_USERNAME`: Docker Hub username
- `DOCKER_PASSWORD`: Docker Hub password
- `AWS_ACCESS_KEY_ID`: AWS access key ID
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key
- `AWS_REGION`: AWS region for the EKS cluster
- `EKS_CLUSTER_NAME`: Name of the EKS cluster

## Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/cloud-assignment.git
   cd cloud-assignment
   ```
2. Build and run the application locally:
   ```bash
   docker build -t cloud-assignment .
   docker run -p 5000:5000 cloud-assignment
   ```
3. Push changes to the `main` branch to trigger the GitHub Actions workflow.

## Contributing
Contributions are welcome! Please submit a pull request with your changes and ensure your code passes all tests.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

