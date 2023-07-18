-- SNOWSQL: snowsql -a <username> -u <login name>

-- create database and schema
create or replace warehouse pc_dbt_wh;

create or replace database raw;
create or replace database analytics;

create or replace schema raw.jaffle_shop;
create or replace schema raw.stripe;

-- create user and role
create or replace user pc_dbt_user password='password' default_role=pc_dbt_role;
create or replace role pc_dbt_role;
grant role pc_dbt_role to user pc_dbt_user;

-- grant permissions
grant usage on warehouse pc_dbt_wh to role pc_dbt_role;
grant usage on database raw to role pc_dbt_role;
grant usage on all schemas in database raw to role pc_dbt_role;
grant usage on future schemas in database raw to role pc_dbt_role;
grant select on all tables in database raw to role pc_dbt_role;
grant select on future tables in database raw to role pc_dbt_role;

grant all privileges on database analytics to role pc_dbt_role;
grant all privileges on all schemas in database analytics to role pc_dbt_role;
grant all privileges on future schemas in database analytics to role pc_dbt_role;
grant select on all tables in database analytics to role pc_dbt_role;
grant select on future tables in database analytics to role pc_dbt_role;

-- CUSTOMERS TABLE
create table raw.jaffle_shop.customers 
( id integer,
  first_name varchar,
  last_name varchar
);

copy into raw.jaffle_shop.customers (id, first_name, last_name)
from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

-- ORDERS TABLE
create table raw.jaffle_shop.orders
( id integer,
  user_id integer,
  order_date date,
  status varchar,
  _etl_loaded_at timestamp default current_timestamp
);

copy into raw.jaffle_shop.orders (id, user_id, order_date, status)
from 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

-- PAYMENT TABLE
create table raw.stripe.payment 
( id integer,
  orderid integer,
  paymentmethod varchar,
  status varchar,
  amount integer,
  created date,
  _batched_at timestamp default current_timestamp
);

copy into raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
from 's3://dbt-tutorial-public/stripe_payments.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

-- VERIFY
select * from raw.jaffle_shop.customers;
select * from raw.jaffle_shop.orders;
select * from raw.stripe.payment;