# SAP HANA Deployment with Docker

This repository contains Docker Compose configurations for deploying a SAP HANA environment with support for SUSE and RedHat platforms. The setup includes a web server (Nginx), an NFS server, and Ansible-managed containers for SLES and RHEL.

## Services Overview

- **Web Server (Nginx):** Serves content and acts as a gateway.
- **NFS Server:** Provides shared storage accessible by NFS clients.
- **Ansible Containers:** Facilitate configuration management for SLES and RHEL environments.

## Prerequisites

- Docker and Docker Compose installed on your host machine.
- Familiarity with Docker, Docker Compose, and Ansible.

## Configuration

Before running the Docker Compose file, ensure you have the following:

1. **Environment Variables:** Define `HOST_IP` in your environment to match your gateway host IP.

2. **Volume Preparation:** Place your Nginx and media content in the `./web/html/` directory as needed.

## Deployment

To deploy the services:

```bash
docker-compose --profile suse up -d
docker-compose --profile redhat up -d
docker-compose --profile web up -d
docker-compose --profile nfs up -d
