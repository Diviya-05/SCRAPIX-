CREATE DATABASE miniproject;
use miniproject;

CREATE TABLE signup (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    
    email VARCHAR(100) UNIQUE,
    mobileno VARCHAR(15),
    username VARCHAR(100),
    password VARCHAR(255)
);
CREATE TABLE login (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    username VARCHAR(100) ,
   
    password VARCHAR(255)
);
use miniproject;
select * from users;
drop table users;
use miniproject;
CREATE DATABASE userdb;
USE userdb;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255)
);
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);
ALTER TABLE users MODIFY COLUMN password VARCHAR(255);
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);
CREATE TABLE scrap_shops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);

CREATE TABLE pickup_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT,
    user_id INT,
    pickup_date DATE NOT NULL,
    FOREIGN KEY (shop_id) REFERENCES scrap_shops(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
select * from scrap_shops;
select * from  pickup_schedules;
-- Create `shops` table
CREATE TABLE `shops` (
  `shop_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `latitude` DOUBLE,
  `longitude` DOUBLE
);

-- Create `pickup_schedules` table
CREATE TABLE `pickup_schedules` (
  `schedule_id` INT AUTO_INCREMENT PRIMARY KEY,
  `shop_id` INT,
  `pickup_date` DATE NOT NULL,
  `available` BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (`shop_id`) REFERENCES `shops`(`shop_id`) ON DELETE CASCADE
);

-- Create `confirmed_schedules` table
CREATE TABLE `confirmed_schedules` (
  `confirmation_id` INT AUTO_INCREMENT PRIMARY KEY,
  `schedule_id` INT,
  `customer_name` VARCHAR(255) NOT NULL,
  `confirmation_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`schedule_id`) REFERENCES `pickup_schedules`(`schedule_id`) ON DELETE CASCADE
);
drop table scrap_shops;
drop table pickup_schedules;
drop table shops;
CREATE TABLE shops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);
CREATE TABLE pickup_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT NOT NULL,
    pickup_date DATE NOT NULL,
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);
CREATE TABLE confirmed_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT NOT NULL,
    pickup_date DATE NOT NULL,
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);
use miniproject;
USE scrap_shop_db;

CREATE TABLE scrap_shops (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique ID for each shop
    name VARCHAR(255) NOT NULL,         -- Name of the scrap shop
    address VARCHAR(255),               -- Address of the shop
    latitude DOUBLE NOT NULL,           -- Latitude of the shop
    longitude DOUBLE NOT NULL,          -- Longitude of the shop
    contact_number VARCHAR(20),         -- Optional: Contact number of the shop
    description TEXT                    -- Optional: Description of the shop
);
drop table scrap_shops;

INSERT INTO scrap_shops (name, address, latitude, longitude, contact_number, description)
VALUES
('Kottayam Scrap Traders', 'Main Road, Kottayam, Kerala', 9.5911, 76.5220, '9745581234', 'Scrap dealer in Kottayam, offering metals, paper, and electronics.'),
('Pathanamthitta Scrap Center', 'Town Hall Road, Pathanamthitta, Kerala', 9.2650, 76.7813, '9845743921', 'Scrap recycling center in Pathanamthitta for metals and e-waste.'),
('Kerala Metal Scrappers', 'MC Road, Kottayam, Kerala', 9.5602, 76.5874, '9532247890', 'Specializes in metal scrap collection and recycling in Kottayam.'),
('Junkyard Recycling Ltd.', 'Changanassery, Kottayam, Kerala', 9.4091, 76.5712, '9447456789', 'Offers recycling services for metals and junk in Kottayam.'),
('Pathanamthitta Recyclers', 'Punalur, Pathanamthitta, Kerala', 9.1022, 76.7463, '9746622345', 'Trusted scrap recycling in Pathanamthitta.'),
('Alappuzha Scrap Hub', 'Alappuzha, Kerala', 9.4922, 76.3382, '9401213456', 'Scrap collection and recycling in Alappuzha and surrounding areas.'),
('Kanjirappally Scrap Solutions', 'Kanjirappally, Kottayam, Kerala', 9.4820, 76.6891, '9389123456', 'Scrap recycling services in Kanjirappally, focusing on metals and e-waste.');


SELECT * FROM scrap_shops;
INSERT INTO scrap_shops (name, address, latitude, longitude, contact_number, description)
VALUES ('SK Scrap Kanjirapally', 'Kanjirappally, Kerala', 9.5525, 76.7968, '9876543210', 'We buy and recycle scrap materials.');


INSERT INTO scrap_shops (name, address, latitude, longitude, contact_number, description) VALUES
('SK Scrap Kanjirapally', 'Kanjirappally, Kerala', 9.5525, 76.7968, '9876543210', 'We buy and recycle scrap materials.'),
('Scrap Traders Ettumanoor', 'Ettumanoor, Kerala', 9.6661, 76.5610, '9847012345', 'Best prices for used metals and plastics.'),
('PK Scrap Enterprise', 'Kottayam, Kerala', 9.5916, 76.5222, '9967456789', 'Buying and selling scrap materials at wholesale rates.'),
('SN Metal Traders', 'Changanassery, Kerala', 9.4554, 76.5368, '9895123456', 'Trusted name in metal scrap trading.'),
('Vaiga Steel Idukki', 'Idukki, Kerala', 9.8495, 76.9685, '9746123456', 'We specialize in steel and iron scrap collection.'),
('GS Scrap and Metals', 'Thodupuzha, Kerala', 9.8892, 76.7180, '9072345678', 'Recycling and trading various metal scraps.');

CREATE TABLE pickup_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT NOT NULL,
    user_id INT NOT NULL,
    user_email VARCHAR(255) NOT NULL,
    pickup_date DATE NOT NULL,
    FOREIGN KEY (shop_id) REFERENCES scrap_shops(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
use miniproject;

CREATE TABLE scrap_selections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId VARCHAR(255) NOT NULL,
    item VARCHAR(255) NOT NULL,
    imagePath VARCHAR(255)  -- Removed the weight column
);
drop table scrap_selections;
CREATE TABLE scrap_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId VARCHAR(255) NOT NULL, -- Unique identifier for the user
  item_name VARCHAR(255), -- Name of the selected scrap item (e.g., Newspaper, Books)
  item_price DECIMAL(10, 2), -- Price of the selected scrap item (e.g., 14.00)
  image_urls TEXT, -- Comma-separated URLs of uploaded images
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp of the record
);
drop table scrap_items;
drop table user_scrap_shop_locations;
CREATE TABLE user_scrap_shop_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_latitude DECIMAL(9, 6),    -- 9 digits in total, 6 digits after the decimal point
    user_longitude DECIMAL(9, 6),   -- 9 digits in total, 6 digits after the decimal point
    shop_name VARCHAR(255),
    shop_latitude DECIMAL(9, 6),    -- 9 digits in total, 6 digits after the decimal point
    shop_longitude DECIMAL(9, 6),   -- 9 digits in total, 6 digits after the decimal point
    contact_number VARCHAR(15),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
drop table users;
ALTER TABLE pickup_requests DROP FOREIGN KEY pickup_requests_ibfk_2;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL
);
use miniproject;

show tables;
CREATE TABLE user_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
drop table  user_locations;
CREATE TABLE user_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    latitude DOUBLE NOT NULL,
    longitude DOUBLE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE pickup_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT NOT NULL,
    user_id INT NOT NULL,
    user_email VARCHAR(255) NOT NULL,
    pickup_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shop_id) REFERENCES scrap_shops(id)
);
drop table pickup_requests;
select * from pickup_requests;
show tables;
select * from users;
drop table shops;
CREATE TABLE app_users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8)
);
CREATE TABLE nearby_shops (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL
);
CREATE TABLE pickup_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  pickup_date DATE NOT NULL,
  FOREIGN KEY (user_id) REFERENCES app_users(id)
);
use miniproject;
select * from scrap_shops;
show tables;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

select * from users;
CREATE TABLE ScrapSelections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255),
    category VARCHAR(255),
    subcategory VARCHAR(255),
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
select * from ScrapSelections;
drop table ScrapSelections;
CREATE TABLE ScrapSelections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255),
    subcategory VARCHAR(255),
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);
select  * from admin;
CREATE TABLE pickup_requests1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_name VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) NOT NULL,
    pickup_date DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
select * from pickup_requests1;
select * from scrap_shops;
select * from users;
ALTER TABLE pickup_requests1 
ADD COLUMN user_id INT NOT NULL,
ADD COLUMN shop_id INT NOT NULL,
DROP COLUMN user_email,
ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
ADD CONSTRAINT fk_shop_id FOREIGN KEY (shop_id) REFERENCES scrap_shops(id);
-- Check invalid user references
SELECT * 
FROM pickup_requests1 
WHERE user_id NOT IN (SELECT id FROM users);

-- Check invalid shop references
SELECT * 
FROM pickup_requests1 
WHERE shop_id NOT IN (SELECT id FROM scrap_shops);
DELETE FROM pickup_requests1 WHERE user_id NOT IN (SELECT id FROM users);
DELETE FROM pickup_requests1 WHERE shop_id NOT IN (SELECT id FROM scrap_shops);

-- Step 1: Add user_id and shop_id columns to pickup_requests1 table without constraints
ALTER TABLE pickup_requests1  
ADD COLUMN user_id INT,
ADD COLUMN shop_id INT;

-- Step 2: Populate user_id and shop_id columns (assign default or placeholder values)
-- Assign the first user ID and first shop ID from their respective tables
UPDATE pickup_requests1
SET user_id = (SELECT id FROM users LIMIT 1),
    shop_id = (SELECT id FROM scrap_shops LIMIT 1);

-- Step 3: Delete invalid rows with non-existent user_id or shop_id
DELETE FROM pickup_requests1 WHERE user_id NOT IN (SELECT id FROM users);
DELETE FROM pickup_requests1 WHERE shop_id NOT IN (SELECT id FROM scrap_shops);

-- Step 4: Add NOT NULL constraints and foreign key relationships
ALTER TABLE pickup_requests1  
MODIFY COLUMN user_id INT NOT NULL,
MODIFY COLUMN shop_id INT NOT NULL,
ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
ADD CONSTRAINT fk_shop_id FOREIGN KEY (shop_id) REFERENCES scrap_shops(id);

-- Step 5: Verify the setup by inserting valid data (optional for testing)
INSERT INTO pickup_requests1 (user_id, shop_id, pickup_date)
VALUES (1, 1, '2025-02-21'); -- Replace 1, 1 with valid user_id and shop_id
UPDATE pickup_requests1
SET user_id = (SELECT id FROM users LIMIT 1),
    shop_id = (SELECT id FROM scrap_shops LIMIT 1);

UPDATE pickup_requests1
SET user_id = (SELECT id FROM users LIMIT 1),
    shop_id = (SELECT id FROM scrap_shops LIMIT 1);



UPDATE pickup_requests1
SET user_id = (SELECT id FROM users LIMIT 1),
    shop_id = (SELECT id FROM scrap_shops LIMIT 1)
WHERE user_id IS NULL OR shop_id IS NULL;
select * from pickup_requests1;
ALTER TABLE pickup_requests1
ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
ADD CONSTRAINT fk_shop_id FOREIGN KEY (shop_id) REFERENCES scrap_shops(id);

ALTER TABLE pickup_requests1
DROP COLUMN user_email,
DROP COLUMN shop_name;
INSERT INTO pickup_requests1 (user_id, shop_id, pickup_date)
VALUES (1, 2, '2025-02-21');
DESCRIBE pickup_requests1;
INSERT INTO pickup_requests1 (user_id, shop_id, pickup_date)
VALUES (1, 2, '2025-02-25 10:00:00');

select * from pickup_requests1 ;
SELECT * FROM users WHERE id = 1; -- Replace with your intended user_id
SELECT * FROM scrap_shops WHERE id = 2; -- Replace with your intended shop_id
use miniproject;

desc users;
desc ScrapSelections;
CREATE TABLE pickup_requests2 (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique ID for the pickup request
    pickup_date DATETIME NOT NULL,             -- Scheduled pickup date
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the request was created
    user_id INT NOT NULL,                      -- References `user.id`
    scrap_selection_id INT,                    -- Optionally references `ScrapSelections.id`
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (scrap_selection_id) REFERENCES ScrapSelections(id) ON DELETE SET NULL
);
desc users;
ALTER TABLE ScrapSelections
    ADD CONSTRAINT fk_email_scrapselections FOREIGN KEY (email) REFERENCES users(email) ON DELETE CASCADE;


desc users;
select  * from users;
CREATE TABLE pickup_requests3 (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique ID for the pickup request
    pickup_date DATETIME NOT NULL,             -- Scheduled pickup date
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the request was created
    email VARCHAR(100) NOT NULL,               -- References user.email
    scrap_selection_id INT,                    -- References ScrapSelections.id
    FOREIGN KEY (email) REFERENCES users(email) ON DELETE CASCADE,
    FOREIGN KEY (scrap_selection_id) REFERENCES ScrapSelections(id) ON DELETE SET NULL
);
select * from ScrapSelections;
desc  ScrapSelections;
select * from pickup_requests1;
desc pickup_requests1;
CREATE TABLE pickups (
  id INT AUTO_INCREMENT PRIMARY KEY,
  shop_name VARCHAR(255) NOT NULL,          -- Name of the scrap shop
  shop_address VARCHAR(255) NOT NULL,       -- Address of the scrap shop
  shop_contact VARCHAR(20) NOT NULL,        -- Contact number of the scrap shop
  user_id INT NOT NULL,                     -- User ID linked to the pickup
  pickup_date DATE NOT NULL,                -- Scheduled pickup date
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp of record creation
);
use miniproject;












