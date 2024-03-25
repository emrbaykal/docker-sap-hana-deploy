#!/bin/bash

# Retrieve host IP address
HOST_IP=$(grep gatewayhost /etc/hosts | awk '{print $1}' | head -n 1)

# Update the all.yml file with the host IP address
sed -i "s/gateway_host_ip:.*/gateway_host_ip: $HOST_IP/" /root/ansible/group_vars/all.yml

# Execute the main container command
exec "$@"
