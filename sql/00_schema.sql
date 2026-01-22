-- 00_schema.sql (SQLite)

DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS returns;

CREATE TABLE customers (
  customer_id TEXT,
  customer_name TEXT,
  region TEXT,
  segment TEXT
);

CREATE TABLE products (
  product_id TEXT,
  product_name TEXT,
  category TEXT,
  unit_cost_gbp REAL
);

CREATE TABLE orders (
  order_id TEXT,
  order_date TEXT,
  ship_date TEXT,
  customer_id TEXT,
  product_id TEXT,
  quantity INTEGER,
  unit_price_gbp REAL,
  status TEXT
);

CREATE TABLE returns (
  order_id TEXT,
  order_date TEXT,
  product_id TEXT,
  customer_id TEXT,
  return_date TEXT,
  return_reason TEXT
);
