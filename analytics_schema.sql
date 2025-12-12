DROP DATABASE IF EXISTS analytics_portfolio;
CREATE DATABASE analytics_portfolio;
USE analytics_portfolio;

-- USERS TABLE
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    country VARCHAR(50),
    device VARCHAR(50),
    marketing_channel VARCHAR(50)
);

-- EVENTS TABLE
CREATE TABLE events (
    event_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_name VARCHAR(50),
    event_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ORDERS TABLE
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_amount DECIMAL(10,2),
    order_time DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- SUBSCRIPTIONS TABLE
CREATE TABLE subscriptions (
    sub_id INT PRIMARY KEY,
    user_id INT,
    start_date DATE,
    end_date DATE,
    plan VARCHAR(20),
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
