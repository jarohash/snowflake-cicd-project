# Snowflake CI/CD Template

This repo deploys SQL files to Snowflake using GitHub Actions + Snowflake CLI + OIDC.

## 1. Replace placeholders

In `admin/00_bootstrap_snowflake_admin.sql`, replace:

```sql
repo:TU_USUARIO_O_ORG/TU_REPO:ref:refs/heads/main
```

with your GitHub owner and repo, for example:

```sql
repo:my-org/my-snowflake-repo:ref:refs/heads/main
```

## 2. Run the Snowflake bootstrap once

Open Snowsight > Worksheets and run:

```sql
admin/00_bootstrap_snowflake_admin.sql
```

This creates:

- `GITHUB_CICD_USER`
- `ROLE_CICD_DEPLOYER`
- `WH_CICD`
- `DB_DEV`

## 3. Add the GitHub secret

In GitHub:

`Settings > Secrets and variables > Actions > New repository secret`

Create:

```text
SNOWFLAKE_ACCOUNT = your-org-your-account
```

## 4. Deploy

Push to `main`. GitHub Actions will run all files inside `/sql` in sorted order.

## 5. Team workflow

Recommended branch model:

```text
feature/my-change -> pull request -> review -> merge to main -> deploy to Snowflake
```

Never commit passwords, tokens, private keys, `.env`, `config.toml`, or `connections.toml`.
