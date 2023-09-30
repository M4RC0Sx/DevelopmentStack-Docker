#!/bin/bash

docker network create traefik-network

# Traefik directory
mkdir traefik
mkdir traefik/certs
touch traefik/acme.json
echo "${X:-"{}"}" > traefik/acme.json
chmod 600 traefik/acme.json
# In case you want to use your own certs.
cp dynamic.yaml traefik/dynamic.yaml

# GitLab directory
mkdir gitlab
mkdir gitlab/config
mkdir gitlab/data
mkdir gitlab/logs

# GitLab runner
mkdir gitlab/runners
mkdir gitlab/runners/cert
openssl s_client -showcerts -connect gitlab.domain.com:443 -servername gitlab.domain.com < /dev/null 2>/dev/null | openssl x509 -outform PEM > gitlab/runners/cert/gitlab.domain.com.crt
mkdir gitlab/runners/runner-1
# Execute on gitlab runner console
# Executor: docker
# gitlab-runner register --url "https://gitlab.domain.com" --registration-token "GITLAB_RUNNER_TOKEN" --tls-ca-file /etc/gitlab-runner/certs/gitlab.domain.com.crt

# Nexus directory
mkdir nexus
mkdir nexus/data
chown -R 200 nexus/data/

# Jenkins directory
mkdir jenkins
mkdir jenkins/data
chown -R 1000 jenkins/data/

# SonarQube directory
mkdir sonarqube
mkdir sonarqube/data
mkdir sonarqube/extensions
mkdir sonarqube/logs

docker compose up -d
