# Electricity Billing System

A Java Swing application for managing electricity billing systems.

## 🚀 Cloud Deployment (NoVNC)

This project is configured to run on **Google Cloud Run** using **NoVNC**. This allows you to access the Desktop GUI application directly through your web browser.

### How it Works
The Docker container runs a full virtual desktop environment:
1.  **Xvfb**: Creates a virtual screen.
2.  **Fluxbox**: Manages windows.
3.  **x11vnc**: Captures the screen.
4.  **NoVNC**: Displays the screen in your browser.

### Accessing the App
Once deployed to Cloud Run, simply visit the Service URL. You will see the application running inside the browser window.

## Prerequisites

- Java Development Kit (JDK) 17
- Apache Ant
- Docker (optional, for containerization)

## Local Development

1.  **Build the project**:
    ```bash
    ant clean jar
    ```
2.  **Run the application**:
    ```bash
    java -jar dist/Electricity_Billing_System.jar
    ```

## Docker Build

You can build the application using Docker.

```bash
# Build the image
docker build -t electricity-billing-system .

# Run the container
docker run -p 8080:8080 electricity-billing-system
```
Then open `http://localhost:8080` in your browser.

## CI/CD Pipeline

This project is configured with **GitHub Actions** to automatically build and deploy to **Google Cloud Platform**.

### Configuration Files
- **`Dockerfile`**: Installs X11, VNC, and Supervisor.
- **`supervisord.conf`**: Manages the display and application processes.
- **`cloudbuild.yaml`**: Google Cloud Build configuration.
- **`.github/workflows/deploy.yaml`**: GitHub Actions workflow.

### Setup Instructions

To enable the CI/CD pipeline, configure the following **Secrets** in your GitHub Repository:

| Secret Name | Description |
| :--- | :--- |
| `GCP_PROJECT_ID` | Your Google Cloud Project ID. |
| `WIF_PROVIDER` | Workload Identity Provider resource name. |
| `WIF_SERVICE_ACCOUNT` | Service Account email for GitHub Actions. |

### Dependencies
The build process automatically downloads:
- `mysql-connector-java-8.0.28.jar` (Maven Central)
- `rs2xml.jar` (GitHub Mirror)
