# Deployment Failure Postmortem

> Copy this file to `docs/postmortems/YYYY-MM-DD-short-title.md` and fill it in. Blameless: describe
> systems and decisions, not people.

## Incident Summary

| Field | Value |
|-------|-------|
| **Date** | YYYY-MM-DD |
| **Duration** | Start time — End time (total minutes) |
| **Severity** | Low / Medium / High / Critical |
| **Affected Resources** | e.g., S3 artifacts bucket, DynamoDB app-state table |
| **Detected By** | CI pipeline / CD pipeline / monitoring / manual |
| **Resolved By** | @github-username |

## Timeline

| Time | Event |
|------|-------|
| HH:MM | PR merged to main |
| HH:MM | CD pipeline started |
| HH:MM | Deployment approved in `production` environment |
| HH:MM | Issue detected (describe how) |
| HH:MM | Rollback initiated |
| HH:MM | Service restored |

## Root Cause

_Describe what caused the failure. Be specific — reference the exact commit, configuration change, or
external factor._

## Impact

_What was affected? Did users experience downtime? Was data at risk?_

## Resolution

_What was done to fix it? Include the specific steps, commands, or rollback procedure._

```bash
# Example rollback: revert the offending commit and redeploy
git revert <commit-hash>
git push origin main
# Wait for the CD pipeline, then approve the deployment in the Actions tab
```

If the revert itself is unsafe (for example, the resource was destroyed rather than modified),
restore from state instead:

```bash
cd terraform
terraform state list
terraform plan          # confirm the diff before touching anything
terraform apply
```

## Lessons Learned

### What went well

- e.g., CI pipeline caught the issue before deploy
- e.g., Rollback procedure worked as documented

### What went wrong

- e.g., Missing validation for edge case
- e.g., No alerting on the affected resource

### Where we got lucky

- e.g., The approval gate delayed the deploy long enough for someone to notice

## Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Add validation for X | @username | YYYY-MM-DD | Open |
| Update monitoring for Y | @username | YYYY-MM-DD | Open |
| Add test case for Z | @username | YYYY-MM-DD | Open |
