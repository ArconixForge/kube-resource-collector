# Kube Resource Collector

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kube-resource-collector)](https://artifacthub.io/packages/helm/kube-resource-collector/kube-resource-collector)
[![Docker Hub](https://img.shields.io/docker/pulls/arconixforge/kube-resource-collector.svg)](https://hub.docker.com/r/arconixforge/kube-resource-collector)

A Kubernetes native application that collects and analyzes resource configurations from your Kubernetes clusters. The tool helps operators monitor, track, and analyze resources like deployments, statefulsets, jobs, configmaps, and secrets.

## Features

- **Resource Tracking**: Collects data on deployments, statefulsets, jobs, configmaps, and secrets
- **Namespace Flexibility**: Monitor specific namespaces or cluster-wide resources
- **Configurable Collection**: Set custom intervals for data collection
- **Database Storage**: Stores collected data in PostgreSQL for historical analysis
- **Low Footprint**: Optimized for minimal resource usage
- **RBAC Support**: Granular permission control (namespace or cluster-wide)

## Architecture

The kube-resource-collector runs as a Deployment within your Kubernetes cluster, using the Kubernetes API to collect resource configurations at defined intervals. Data is stored in a PostgreSQL database for analysis and reporting.

```
┌─────────────────┐      ┌───────────────┐      ┌─────────────┐
│ Kubernetes API  │◄───►│ Collector Pod  │◄───►│ PostgreSQL  │
└─────────────────┘      └───────────────┘      └─────────────┘
```

## Installation

### Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- PostgreSQL instance (can be in-cluster or external)

### Using Helm

1. Add the Helm repository:

```bash
helm repo add arconixforge https://arconixforge.github.io/helm-charts
helm repo update
```

2. Install the chart:

```bash
helm install kube-resource-collector arconixforge/kube-resource-collector \
  --namespace k8-collector \
  --create-namespace \
  --values custom-values.yaml
```

### Configuration

Create a `custom-values.yaml` file to override default values:

```yaml
replicaCount: 1

database:
  host: your-postgres-host
  port: 5432
  user: postgres-user
  name: resource_db
  password: secure-password
  secretName: postgres-secret

namespaces: app-ns,core-ns  # Comma-separated list of namespaces to monitor
collection_interval: 300     # Collection interval in seconds

rbac:
  create: true
  clusterRole: true         # Set to false for namespace-scoped permissions

serviceAccount:
  create: true
  name: "kube-resource-collector-sa"

resources:
  limits:
    cpu: "500m"
    memory: "512Mi"
  requests:
    cpu: "250m"
    memory: "256Mi"
```

## Security Considerations

### RBAC Permissions

The collector requires read-only access to Kubernetes resources:

- For cluster-wide collection: ClusterRole and ClusterRoleBinding
- For namespace-specific collection: Role and RoleBinding

### Security Context

The application runs with:
- Read-only root filesystem
- Dropped capabilities
- Non-root user

## Usage

Once installed, the collector will automatically begin gathering resource data based on your configuration.

### Available Commands

```bash
# Check deployment status
helm status kube-resource-collector --namespace k8-collector

# Update configuration
helm upgrade kube-resource-collector arconixforge/kube-resource-collector \
  --namespace k8-collector \
  --values updated-values.yaml

# Uninstall
helm uninstall kube-resource-collector --namespace k8-collector
```

### Accessing Collected Data

Connect to your PostgreSQL database to query the collected data. Schema documentation will be available in a separate guide.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Maintainers

- [ArconixForge](https://github.com/ArconixForge)

## Acknowledgements

- Kubernetes community
- Helm community