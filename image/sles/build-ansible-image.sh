#!/bin/bash

docker build -t emrebaykal/ansible-sles .
docker run --rm -it emrebaykal/ansible-sles ansible --version
