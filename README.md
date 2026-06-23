# CI/CD Demo — Jenkins → Docker → VM

This repository contains a minimal Node.js web app and a Jenkins Declarative Pipeline (Jenkinsfile) demonstrating an end-to-end CI/CD flow.

Files:
- `Jenkinsfile`: Declarative pipeline with Checkout, Build, Test, Package, Docker Build, Push (optional), Approval (optional), Deploy
- `Dockerfile`: builds a Docker image for the app
- `app/server.js`, `lib/greet.js`: simple Express app
- `test/test.js`: simple unit test
- `scripts/deploy.sh`: helper script to deploy image to a VM via SSH

Quick setup

1. Push this repo to GitHub.
2. On Jenkins:
   - Create a new Pipeline job and point it to the GitHub repo (use `Jenkinsfile` from repo).
   - Add credentials:
     - `ssh-credentials-id` (SSH Username with private key) for the target VM user.
     - Optional: Docker Hub credentials stored as a username/password; set the credentials id in the pipeline environment variable `DOCKERHUB_CREDENTIALS_ID`.
   - Configure environment variable `VM_IP` (or pass as pipeline parameter) with the target VM IP.
3. Configure a GitHub webhook: in the repo Settings → Webhooks add your Jenkins GitHub webhook URL (e.g., `https://<JENKINS>/github-webhook/`).

To run locally:

Install deps and start:
```bash
npm ci
npm start
```
Run tests:
```bash
npm test
```

Notes
- Replace `yourdockerhubuser/ci-cd-demo` in `Jenkinsfile` with your Docker Hub repo if you plan to push images.
- The `Deploy` stage uses SSH to the VM and requires Docker to be installed on the VM and the SSH key credential configured in Jenkins.
