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

Usage: compose-lnx.sh action [redhat|suse]
action:
    start   Start Docker Compose Services For the Given Profile.
    stop    Stop Docker Compose Services For the Given Profile.
    connect Connect Docker Compose Services For the Given Profile.
    status  Show Docker Compose Status.
    cleanup Cleaning up  Docker Compose Service Resources.
    help    Display Help Message.
profile:
    redhat  Start/Stop Docker Redhat Compose services.
    suse    Start/Stop Docker Suse Compose services.