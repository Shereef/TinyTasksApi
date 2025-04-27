# TinyTasksApi

TinyTasksApi is a simple task management API built with ASP.NET Core. It allows users to create, retrieve, update, and delete tasks. The project is containerized using Docker and deployable to AWS using Terraform.

## Features

- **CRUD Operations**: Create, Read, Update, and Delete tasks.
- **Swagger Integration**: API documentation and testing via Swagger UI.
- **Docker Support**: Development and production-ready Docker configurations.
- **AWS Deployment**: Infrastructure as Code (IaC) using Terraform for AWS deployment.
- **Dev Container**: Ready-to-use development container with Visual Studio Code integration.

## Prerequisites

- [.NET 9.0 SDK](https://dotnet.microsoft.com/)
- [Docker](https://www.docker.com/)
- [Terraform](https://www.terraform.io/)
- AWS CLI (for deployment)

## Getting Started

### Running Locally

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd TinyTasksApi
   ```

2. Restore dependencies:
   ```bash
   dotnet restore
   ```

3. Run the application:
   ```bash
   dotnet run
   ```

4. Access the API at:
   - Swagger UI: [http://localhost:5131](http://localhost:5131)

### Running with Docker

1. Build the Docker image:
   ```bash
   docker build -t tinytasksapi .
   ```

2. Run the container:
   ```bash
   docker run -p 80:80 tinytasksapi
   ```

3. Access the API at:
   - Swagger UI: [http://localhost](http://localhost)

### Running in Development Mode with Docker Compose

1. Start the development container:
   ```bash
   docker-compose up
   ```

2. Access the API at:
   - Swagger UI: [http://localhost](http://localhost)

### Deploying to AWS

1. Configure AWS credentials:
   ```bash
   aws configure
   ```

2. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

3. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

4. Access the deployed API using the output values from Terraform.

## API Endpoints

- **GET** `/tasks`: Retrieve all tasks.
- **GET** `/tasks/{id}`: Retrieve a task by ID.
- **POST** `/tasks`: Create a new task.
- **PUT** `/tasks/{id}`: Fully update a task by ID.
- **PATCH** `/tasks/{id}`: Partially update a task by ID.
- **DELETE** `/tasks/{id}`: Delete a task by ID.

## Configuration

- **`appsettings.json`**: Configure logging and allowed hosts.
- **`launchSettings.json`**: Configure local development settings.

## Development

This project includes a development container configuration (`.devcontainer/devcontainer.json`) for Visual Studio Code. To use it:

1. Install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.
2. Open the project in VS Code and reopen in the container.

## Infrastructure

The Terraform configuration in the `terraform` directory sets up the following AWS resources:

- VPC, Subnet, and Security Group
- ECS Cluster, Task Definition, and Service
- ECR Repository for container images

## License

This project is licensed under the MIT License.
