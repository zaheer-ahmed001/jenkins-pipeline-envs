# jenkins-pipeline-envs

A multi-environment CI/CD pipeline using Jenkins and Docker Compose.
Automatically deploys to dev, staging, or production based on the Git branch pushed.

## Architecture

- **dev branch** → deploys dev environment (port 8081)
- **staging branch** → deploys staging environment (port 8082)
- **main branch** → deploys prod environment (port 8083)

Each environment runs an isolated Docker Compose stack with:
- Nginx as a web server
- PostgreSQL with a persistent named volume
- Dedicated bridge network per environment

## Pipeline Stages

1. Clone Repository
2. Set Environment (detects branch → assigns env + port)
3. Tear Down Old Stack
4. Deploy Stack
5. Health Check (curl-based HTTP 200 check)
6. Verify Running Containers

## Tech Stack

- Jenkins (Multibranch Pipeline)
- Docker & Docker Compose
- Nginx
- PostgreSQL
- Bash scripting
- GitHub

## Project Structure

\`\`\`
jenkins-pipeline-envs/
├── docker-compose.dev.yml
├── docker-compose.staging.yml
├── docker-compose.prod.yml
├── nginx/
│   └── nginx.conf
├── scripts/
│   └── healthcheck.sh
├── Jenkinsfile
└── README.md
\`\`\`

## How to Run Locally

\`\`\`bash
# dev
docker compose -f docker-compose.dev.yml up -d

# staging
docker compose -f docker-compose.staging.yml up -d

# prod
docker compose -f docker-compose.prod.yml up -d
\`\`\`
