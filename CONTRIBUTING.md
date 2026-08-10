# Contributing Guide

## Commit Conventions

This repository uses [Conventional Commits](https://www.conventionalcommits.org/). All PR titles
**must** follow this format:

```
type: short description
```

The [Commit Lint](.github/workflows/commit-lint.yml) workflow checks every PR title and fails the
check if it does not match. Because we squash merge, the PR title becomes the commit message on
`main` — which is what `release-please` reads to decide the next version number.

### Allowed Types

| Type | When to Use | Example |
|------|------------|---------|
| `feat` | New infrastructure resource | `feat: add CloudWatch alarm for DynamoDB` |
| `fix` | Bug fix or misconfiguration | `fix: correct S3 bucket policy permissions` |
| `docs` | Documentation only | `docs: update architecture diagram` |
| `chore` | Maintenance, dependencies | `chore: update Terraform provider to 5.30` |
| `refactor` | Code restructuring, no behavior change | `refactor: extract S3 config into module` |
| `ci` | CI/CD workflow changes | `ci: add tfsec to pull request checks` |
| `test` | Adding or updating tests | `test: add validation for DynamoDB schema` |
| `perf` | Performance improvement | `perf: cache providers between CI jobs` |

### How the type affects the version

| Commit type | Version bump | `0.1.0` becomes |
|-------------|--------------|-----------------|
| `fix:` | patch | `0.1.1` |
| `feat:` | minor | `0.2.0` |
| any type with `!` or a `BREAKING CHANGE:` footer | major | `1.0.0` |
| `docs:`, `chore:`, `ci:`, `test:`, `refactor:` | none | `0.1.0` |

## Pull Request Process

1. Create a feature branch from `main`: `git checkout -b feat/your-feature`
2. Make changes and commit with conventional messages
3. Push and open a PR with a conventional title
4. CI pipeline runs automatically — all checks must pass
5. Get at least one approval from a reviewer
6. Squash merge to `main`
7. CD pipeline runs and waits for production approval

## CI Pipeline Checks

Every PR touching `terraform/**` must pass these checks before merge:

- **Terraform Format** — `terraform fmt -check -recursive -diff`
- **Terraform Validate** — `terraform init -backend=false && terraform validate`
- **Security Scan** — tfsec checks the configuration for misconfigurations
- **Terraform Plan** — plan output posted as a PR comment with a results table

The first three run in parallel; `plan` runs only if all three pass.

## Deployment

Merges to `main` that touch `terraform/**` trigger the CD pipeline:

1. Automatic `terraform plan`
2. **Manual approval required** in the `production` environment — the `deploy` job waits in
   *Waiting* status until a reviewer approves it in the Actions UI
3. `terraform apply` executes after approval

To approve: open the run in the **Actions** tab → **Review deployments** → tick `production` →
**Approve and deploy**. Rejecting cancels the job and nothing is applied.

## Security

- Never commit `.tfvars` files with real values — `.gitignore` blocks them, keep it that way
- Use GitHub Secrets for AWS credentials; never inline them in a workflow
- All S3 buckets must have encryption and public access blocks
- DynamoDB tables must enable encryption and point-in-time recovery
- Workflow permissions are scoped per file (`contents: read` unless a job genuinely needs to write)
- Pin third-party actions to a tag, and review the diff when bumping one

## Local Development

```bash
cd terraform
terraform fmt -recursive        # fix formatting before pushing — CI only checks
terraform init -backend=false
terraform validate
```

Running `terraform fmt` before you push is the single easiest way to avoid a red CI run.
