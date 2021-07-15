create database aiot_erp;
create user aiotdb with password 'Aiotdb@2021' login;
create user sync with password 'sync' login;
\c aiot_erp

-- 建表

-- 授权 database
GRANT CONNECT ON DATABASE aiot_erp TO aiotdb;
GRANT CONNECT ON DATABASE aiot_erp TO sync;

-- 授权 schema 
GRANT usage ON SCHEMA PUBLIC TO aiotdb;
GRANT usage ON SCHEMA PUBLIC TO sync;

-- 授权 table
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PUBLIC TO sync; 
