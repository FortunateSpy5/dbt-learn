-- Use an admin role
USE ROLE ACCOUNTADMIN;

-- Create the role
CREATE ROLE IF NOT EXISTS pc_dbt_role;
GRANT ROLE pc_dbt_role TO ROLE ACCOUNTADMIN;

-- Create the default warehouse if necessary
CREATE WAREHOUSE IF NOT EXISTS pc_dbt_wh;
GRANT OPERATE ON WAREHOUSE pc_dbt_wh TO ROLE pc_dbt_role;

-- Create the `dbt` user and assign to role
CREATE USER IF NOT EXISTS pc_dbt_user
  PASSWORD='password'
  LOGIN_NAME='pc_dbt_user'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='pc_dbt_wh'
  DEFAULT_ROLE='pc_dbt_role'
  DEFAULT_NAMESPACE='AIRBNB.RAW'
  COMMENT='DBT user used for data transformation';
GRANT ROLE pc_dbt_role to USER pc_dbt_user;

-- Create our database and schemas
CREATE DATABASE IF NOT EXISTS AIRBNB;
CREATE SCHEMA IF NOT EXISTS AIRBNB.RAW;

-- Set up permissions to role `transform`
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE pc_dbt_role; 
GRANT ALL ON DATABASE AIRBNB to ROLE pc_dbt_role;
GRANT ALL ON ALL SCHEMAS IN DATABASE AIRBNB to ROLE pc_dbt_role;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE AIRBNB to ROLE pc_dbt_role;
GRANT ALL ON ALL TABLES IN SCHEMA AIRBNB.RAW to ROLE pc_dbt_role;
GRANT ALL ON FUTURE TABLES IN SCHEMA AIRBNB.RAW to ROLE pc_dbt_role;