CREATE DATABASE financial_portfolio;

USE financial_portfolio;

CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(255)
);

CREATE TABLE portfolios (
    portfolio_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    portfolio_name VARCHAR(100) NOT NULL,
    other_details VARCHAR(255),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

CREATE TABLE investments (
    investment_id INT PRIMARY KEY AUTO_INCREMENT,
    portfolio_id INT,
    investment_type VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    investment_date DATE,
    other_details VARCHAR(255),
    FOREIGN KEY (portfolio_id) REFERENCES portfolios(portfolio_id)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY AUTO_INCREMENT,
    investment_id INT,
    return_percentage DECIMAL(5, 2) NOT NULL,
    return_amount DECIMAL(10, 2) NOT NULL,
    return_date DATE,
    other_details VARCHAR(255),
    FOREIGN KEY (investment_id) REFERENCES investments(investment_id)
);

-- Inserting Data for a single client

-- Inserting Data Into Clients Table

INSERT INTO clients (name, contact_info)
VALUES ('Alex Johnson', '4165551234');

-- Retrieving the client_id of the inserted client
SET @client_id := LAST_INSERT_ID();

-- Inserting data into 'portfolios' table
INSERT INTO portfolios (client_id, portfolio_name, other_details)
VALUES (@client_id, 'My Portfolio', 'Long-term investments');

-- Retrieving the portfolio_id of the inserted portfolio
SET @portfolio_id := LAST_INSERT_ID();

-- Inserting data into 'investments' table
INSERT INTO investments (portfolio_id, investment_type, amount, investment_date, other_details)
VALUES (@portfolio_id, 'Equity', 50000, '2021-01-01', 'Stocks');

-- Retrieving the investment_id of the inserted investment
SET @investment_id := LAST_INSERT_ID();

-- Inserting data into 'returns' table
INSERT INTO returns (investment_id, return_percentage, return_amount, return_date, other_details)
VALUES (@investment_id, 10.2, 10000, '2021-04-01', 'Returns for Q1 2021');

-- Inserting Bulk data For Clients
INSERT INTO clients (name, contact_info)
VALUES 
    ('Liam Johnson', '+14165551234'),
    ('Emma Smith', '+16475555678'),
    ('Olivia Martinez', '+19055557890'),
    ('Noah Davis', '+15195554321'),
    ('Sophia Taylor', '+12265558765'),
    ('Lucas Anderson', '+12895552109'),
    ('Isabella Lee', '+19055559876'),
    ('Mason Murphy', '+16135555432'),
    ('Eva Brown', '+17785556543');

-- Inserting bulk Data for Portfolios
INSERT INTO portfolios (client_id, portfolio_name, other_details)
VALUES
    (2, 'Equity Portfolio', 'Long-term investments'),
    (3, 'Commodity Portfolio', 'Diversified investments'),
    (4, 'Equity Portfolio', 'Long-term investments'),
    (4, 'Real Estate Portfolio', 'Property investments'),
    (5, 'Debt Portfolio', 'Short-term investments'),
    (6, 'Equity Portfolio', 'Long-term investments'),
    (7, 'Debt Portfolio', 'Short-term investments'),
    (8, 'Commodity Portfolio', 'Diversified investments'),
    (9, 'Equity Portfolio', 'Long-term investments'),
    (10, 'Debt Portfolio', 'Short-term investments');

-- Inserting Bulk data For Investments
INSERT INTO investments (portfolio_id, investment_type, amount, investment_date, other_details)
VALUES
    (2, 'Equity', 75000.00, '2021-12-31', 'Long-term investment'),
    (3, 'Commodity', 25000.00, '2021-11-15', 'Diversified investment'),
    (4, 'Equity', 200000.00, '2022-03-01', 'Long-term investment'),
    (4, 'Real Estate', 5000000.00, '2021-10-20', 'Property investment'),
    (5, 'Debt', 100000.00, '2021-09-01', 'Short-term investment'),
    (6, 'Equity', 500000.00, '2021-08-15', 'Long-term investment'),
    (7, 'Debt', 75000.00, '2022-02-28', 'Short-term investment'),
    (8, 'Commodity', 100000.00, '2022-03-10', 'Diversified investment'),
    (9, 'Equity', 150000.00, '2022-01-20', 'Long-term investment'),
    (10, 'Debt', 30000.00, '2021-11-30', 'Short-term investment');

-- Inserting Bulk Data For returns
INSERT INTO returns (investment_id, return_percentage, return_amount, return_date, other_details)
VALUES
    (2, 8.50, 4250.00, '2022-04-01', 'Quarterly returns'),
    (3, 7.00, 1750.00, '2022-03-01', 'Monthly returns'),
    (4, 12.75, 25500.00, '2022-06-01', 'Quarterly returns'),
    (4, 10.00, 500000.00, '2022-01-01', 'Yearly returns'),
    (5, 6.25, 6250.00, '2022-05-15', 'Quarterly returns'),
    (6, 9.75, 4875.00, '2022-03-15', 'Quarterly returns'),
    (7, 5.50, 4125.00, '2022-06-15', 'Quarterly returns'),
    (8, 4.00, 4000.00, '2022-02-15', 'Monthly returns'),
    (9, 11.25, 16875.00, '2022-05-20', 'Quarterly returns'),
    (10, 6.00, 1800.00, '2022-04-30', 'Monthly returns');

-- 1 Query: Retrieve all client names and their contact information.
SELECT name, contact_info FROM clients;

-- 2 Query: Retrieve all portfolio names along with their corresponding client names
SELECT p.portfolio_name, c.name
FROM portfolios p
JOIN clients c ON p.client_id = c.client_id;

-- 3 Query: Retrieve the total investment amount for each portfolio
SELECT p.portfolio_name, SUM(i.amount) AS total_investment_amount
FROM portfolios p
JOIN investments i ON p.portfolio_id = i.portfolio_id
GROUP BY p.portfolio_name;

-- 4 Query: Retrieve all investments made in a specific investment type.
SELECT i.investment_type, i.amount, p.portfolio_name
FROM investments i
JOIN portfolios p ON i.portfolio_id = p.portfolio_id
WHERE i.investment_type = 'Stocks';


-- 5 Query: Retrieve the average return percentage for each investment type.
SELECT i.investment_type, AVG(r.return_percentage) AS average_return_percentage
FROM investments i
JOIN returns r ON i.investment_id = r.investment_id
GROUP BY i.investment_type;

-- 6 Query : Retrieve the total return amount for each investment type, along with the corresponding portfolio 
                  -- and client information.
SELECT i.investment_type, r.return_amount, p.portfolio_name, c.name
FROM returns r
JOIN investments i ON r.investment_id = i.investment_id
JOIN portfolios p ON i.portfolio_id = p.portfolio_id
JOIN clients c ON p.client_id = c.client_id
ORDER BY i.investment_type, r.return_amount DESC;       

-- 7 Query: Retrieve the top 5 portfolios with the highest total investment amount  
SELECT p.portfolio_name, SUM(i.amount) AS total_investment_amount
FROM portfolios p
JOIN investments i ON p.portfolio_id = i.portfolio_id
GROUP BY p.portfolio_name
ORDER BY total_investment_amount DESC
LIMIT 5;    

-- 8 Query: Retrieve the investments made in the past year along with the corresponding portfolio and client information.
SELECT i.investment_type, i.amount, i.investment_date, p.portfolio_name, c.name
FROM investments i
JOIN portfolios p ON i.portfolio_id = p.portfolio_id
JOIN clients c ON p.client_id = c.client_id
WHERE i.investment_date > DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- 9 Query: Retrieve the clients who have investments in multiple portfolios.
SELECT c.name, COUNT(DISTINCT p.portfolio_id) AS num_portfolios
FROM clients c
JOIN portfolios p ON c.client_id = p.client_id
JOIN investments i ON p.portfolio_id = i.portfolio_id
GROUP BY c.name
HAVING COUNT(DISTINCT p.portfolio_id) > 1;

-- 10 Query: Retrieve the portfolios with a total return amount higher than the average return amount.
SELECT p.portfolio_name, SUM(r.return_amount) AS total_return_amount 
FROM portfolios p
JOIN investments i ON p.portfolio_id = i.portfolio_id 
JOIN returns r ON i.investment_id = r.investment_id 
GROUP BY p.portfolio_name
HAVING total_return_amount > (SELECT AVG(return_amount) FROM returns);

-- 11 Query: Retrieve the top 3 clients with the highest total investment amount 
               -- across all portfolios, along with the corresponding portfolio and investment information.
SELECT c.name, p.portfolio_name, i.investment_type, i.amount
FROM clients c
JOIN portfolios p ON c.client_id = p.client_id
JOIN investments i ON p.portfolio_id = i.portfolio_id
ORDER BY (SELECT SUM(amount) FROM investments WHERE portfolio_id = p.portfolio_id) DESC
LIMIT 3;

-- 12 Query: Retrieve the portfolios with the highest average return percentage, along with the corresponding investment and client information.
SELECT p.portfolio_name, AVG(r.return_percentage) AS avg_return_percentage, i.investment_type, c.name
FROM portfolios p
JOIN investments i ON p.portfolio_id = i.portfolio_id
JOIN returns r ON i.investment_id = r.investment_id
JOIN clients c ON p.client_id = c.client_id
GROUP BY p.portfolio_name, i.investment_type, c.name
ORDER BY avg_return_percentage;

-- 13 Query: Retrieve the investments that have not yet received any returns.
SELECT i.investment_type, i.amount, i.investment_date, p.portfolio_name, c.name 
FROM investments i
JOIN portfolios p ON i.portfolio_id = p.portfolio_id 
JOIN clients c ON p.client_id = c.client_id
LEFT JOIN returns r ON i.investment_id = r.investment_id
 WHERE r.return_id IS NULL;

-- 14 Query: Retrieve the clients who have investments in all portfolios.
SELECT c.name 
FROM clients c
JOIN portfolios p ON c.client_id = p.client_id
LEFT JOIN investments i ON p.portfolio_id = i.portfolio_id 
GROUP BY c.name
HAVING COUNT(DISTINCT p.portfolio_id) = COUNT(DISTINCT i.portfolio_id);

-- 15  Query: Retrieve the portfolios with the highest total investment amount for each client.
SELECT c.name, p.portfolio_name, total_investment_amount
FROM (
    SELECT p.portfolio_id, SUM(i.amount) AS total_investment_amount
    FROM portfolios p
    JOIN investments i ON p.portfolio_id = i.portfolio_id
    GROUP BY p.portfolio_id
) AS portfolio_investment
JOIN portfolios p ON portfolio_investment.portfolio_id = p.portfolio_id
JOIN clients c ON p.client_id = c.client_id
WHERE total_investment_amount = (
    SELECT MAX(total_investment_amount)
    FROM (
        SELECT p.portfolio_id, SUM(i.amount) AS total_investment_amount
        FROM portfolios p
        JOIN investments i ON p.portfolio_id = i.portfolio_id
        GROUP BY p.portfolio_id
    ) AS subquery
);






