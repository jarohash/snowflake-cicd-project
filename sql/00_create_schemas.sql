USE DATABASE DB_DEV;

CREATE SCHEMA IF NOT EXISTS RAW
  COMMENT = 'Landing/raw layer for source data';

CREATE SCHEMA IF NOT EXISTS STAGING
  COMMENT = 'Cleaned and standardized data layer';

CREATE SCHEMA IF NOT EXISTS MART
  COMMENT = 'Business-ready analytics layer';
