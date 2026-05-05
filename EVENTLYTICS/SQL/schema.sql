CREATE DATABASE eventlytics;

USE eventlytics;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    city VARCHAR(100)
);

CREATE TABLE events (
    event_id INT PRIMARY KEY,
    user_id INT,
    event_type VARCHAR(100),
    event_date DATE,
    city_from VARCHAR(100),
    city_to VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE transactions_food (
    transaction_id INT PRIMARY KEY,
    user_id INT,
    transaction_date DATE,
    category VARCHAR(100),
    amount DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);