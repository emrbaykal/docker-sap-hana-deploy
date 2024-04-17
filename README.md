# SAP HANA Deployment with Docker

This repository contains Docker Compose configurations for deploying a SAP HANA environment with support for SUSE and RedHat platforms. The setup includes a web server (Nginx), and Ansible-managed containers for SLES and RHEL.

## Services Overview

- **Web Server (Nginx):** Serves content and acts as a gateway.
- **NFS Server:** Provides shared storage accessible by NFS clients.
- **Ansible Containers:** Facilitate configuration management for SLES and RHEL environments.

## Prerequisites

- Docker and Docker Compose installed on your host machine.
- NFS-Server Packages installed on your host machine.
- Familiarity with Docker, Docker Compose, and Ansible.

## Supported Operating Systems

- Redhat Enterprise Linux, Ubuntu Server
- Mac OS X

## Usage

```bash
./compose-lnx.sh action [profile]

Actions:
start: Start Docker Compose services for the given profile.
stop: Stop Docker Compose services for the given profile.
connect: Connect to Docker Compose services for the given profile.
status: Show the status of Docker Compose services.
cleanup: Clean up Docker Compose service resources.
Profiles:
redhat: Manage Docker Redhat Compose services.
suse: Manage Docker Suse Compose services.