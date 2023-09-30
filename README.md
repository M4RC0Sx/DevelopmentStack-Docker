# DevelopmentStack-Docker

Docker compose file to set up a development and CI/CD stack.

## Cloudflare setup

- Encryption mode = Full (strict)
- Always use HTTPS = true
- Page rules:
  - (#1) \*domain.com/.well-known/acme-challenge/\* >> SSL: Off
  - (#2) \*domain.com/\* >> Always use HTTPS

## Sonarqube GitLab integration

- Create an application on GitLab:

  - Name: SonarQube
  - Redirect URL: https://sonarqube.domain.com/oauth2/callback/gitlab
  - Trusted: true
  - Confidential: true
  - Scopes: api, read_user

- Configure GitLab Auth. integration on SonarQube:

  - Enabled: true
  - GitLab URL: https://gitlab.domain.com
  - Application ID: provided by GitLab
  - Secret: provided by GitLab
  - Allow users to sign-up: true
  - Sync. user groups: true

- Create a master user on SonarQube and setup a token of type "User". The user must have all permissions related to projects and analysis.

- Set the token as a CI/CD global masked variable on GitLab.

- Example pipeline for code analysis:

```
quality-gate:
    image: sonarsource/sonar-scanner-cli:latest
    stage: sonar
    only:
        - master
    variables:
        SONAR_TOKEN: "$SONARQUBE_TOKEN"
        SONAR_URL: "https://sonarqube.domain.com"
        GIT_DEPTH: 0
    script:
        - sonar-scanner -X -Dsonar.qualitygate.wait=true -Dsonar.projectKey=test
```
