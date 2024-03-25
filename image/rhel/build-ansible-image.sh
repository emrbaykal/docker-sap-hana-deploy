#!/bin/bash

docker build -t emrebaykal/ansible-rhel .
docker run --rm -it emrebaykal/ansible-rhel ansible --version
