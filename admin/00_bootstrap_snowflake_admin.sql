-- Run this ONCE in Snowsight with an admin role.
-- Replace TU_USUARIO_O_ORG/TU_REPO with your real GitHub owner/repository.
-- Example subject: repo:alejandro/snowflake-project:ref:refs/heads/main

USE ROLE USERADMIN;

CREATE ROLE IF NOT EXISTS ROLE_CICD_DEPLOYER;

CREATE USER IF NOT EXISTS GITHUB_CICD_USER
  TYPE = SERVICE
  WORKLOAD_IDENTITY = (
    TYPE = OIDC
    ISSUER = 'https://token.actions.githubusercontent.com'
    SUBJECT = 'repo:jarohash/snowflake-cicd-project:ref:refs/heads/main'
  )
  DEFAULT_ROLE = ROLE_CICD_DEPLOYER;

USE ROLE SECURITYADMIN;

GRANT ROLE ROLE_CICD_DEPLOYER TO USER GITHUB_CICD_USER;

USE ROLE SYSADMIN;

CREATE WAREHOUSE IF NOT EXISTS WH_CICD
  WAREHOUSE_SIZE = XSMALL
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'Warehouse used by GitHub Actions CI/CD deployments';

CREATE DATABASE IF NOT EXISTS DB_DEV
  COMMENT = 'Development database deployed through GitHub Actions';

USE ROLE SECURITYADMIN;

GRANT USAGE ON WAREHOUSE WH_CICD TO ROLE ROLE_CICD_DEPLOYER;
GRANT USAGE ON DATABASE DB_DEV TO ROLE ROLE_CICD_DEPLOYER;
GRANT CREATE SCHEMA ON DATABASE DB_DEV TO ROLE ROLE_CICD_DEPLOYER;

-- Optional: keep this role narrow in production. Only grant the minimum privileges needed.
