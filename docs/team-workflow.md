# Team Workflow

## Branches

Each teammate works in their own branch:

```bash
git checkout -b feature/create-customer-table
```

## Changes

Add or edit SQL files in `/sql`. Use numeric prefixes so deployment order is clear:

```text
00_create_schemas.sql
01_create_tables.sql
02_create_views.sql
03_create_tasks.sql
```

## Pull Request

Open a Pull Request before merging to `main`. The team reviews SQL changes before deployment.

## Deploy

Only merges to `main` deploy to Snowflake.
