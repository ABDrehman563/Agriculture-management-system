CREATE DATABASE IF NOT EXISTS farm_management;
USE farm_management;

DROP TABLE IF EXISTS Disease;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Harvests;
DROP TABLE IF EXISTS Crop_Fertilizer;
DROP TABLE IF EXISTS Fertilizers;
DROP TABLE IF EXISTS Irrigation;
DROP TABLE IF EXISTS Plantation;
DROP TABLE IF EXISTS Crops;
DROP TABLE IF EXISTS Farms;
DROP TABLE IF EXISTS Farmers;

CREATE TABLE Farmers (
    farmer_id   INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    contact_no  VARCHAR(15),
    address     VARCHAR(255),
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Farms (
    farm_id     INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id   INT NOT NULL,
    farm_name   VARCHAR(100),
    location    VARCHAR(255),
    area_acres  DECIMAL(10,2),
    soil_type   VARCHAR(50),
    CONSTRAINT fk_farm_farmer FOREIGN KEY (farmer_id)
        REFERENCES Farmers(farmer_id) ON DELETE CASCADE
);

CREATE TABLE Crops (
    crop_id       INT AUTO_INCREMENT PRIMARY KEY,
    crop_name     VARCHAR(100) NOT NULL,
    season        VARCHAR(50),
    duration_days INT
);

CREATE TABLE Plantation (
    plantation_id    INT AUTO_INCREMENT PRIMARY KEY,
    farm_id          INT NOT NULL,
    crop_id          INT NOT NULL,
    planting_date    DATE NOT NULL,
    expected_harvest DATE,
    status           VARCHAR(30) DEFAULT 'Active',
    CONSTRAINT fk_plant_farm FOREIGN KEY (farm_id)
        REFERENCES Farms(farm_id) ON DELETE CASCADE,
    CONSTRAINT fk_plant_crop FOREIGN KEY (crop_id)
        REFERENCES Crops(crop_id) ON DELETE CASCADE
);

CREATE TABLE Irrigation (
    irrigation_id  INT AUTO_INCREMENT PRIMARY KEY,
    plantation_id  INT NOT NULL,
    method         VARCHAR(50),
    frequency_days INT,
    last_irrigated DATE,
    water_source   VARCHAR(100),
    CONSTRAINT fk_irr_plant FOREIGN KEY (plantation_id)
        REFERENCES Plantation(plantation_id) ON DELETE CASCADE
);

CREATE TABLE Fertilizers (
    fertilizer_id   INT AUTO_INCREMENT PRIMARY KEY,
    fertilizer_name VARCHAR(100) NOT NULL,
    type            VARCHAR(50),
    npk_ratio       VARCHAR(30)
);

CREATE TABLE Crop_Fertilizer (
    cf_id            INT AUTO_INCREMENT PRIMARY KEY,
    crop_id          INT NOT NULL,
    fertilizer_id    INT NOT NULL,
    application_date DATE,
    quantity_kg      DECIMAL(8,2),
    CONSTRAINT fk_cf_crop FOREIGN KEY (crop_id)
        REFERENCES Crops(crop_id) ON DELETE CASCADE,
    CONSTRAINT fk_cf_fert FOREIGN KEY (fertilizer_id)
        REFERENCES Fertilizers(fertilizer_id) ON DELETE CASCADE
);

CREATE TABLE Harvests (
    harvest_id    INT AUTO_INCREMENT PRIMARY KEY,
    plantation_id INT NOT NULL,
    harvest_date  DATE NOT NULL,
    quantity_kg   DECIMAL(10,2),
    quality_grade VARCHAR(10),
    notes         TEXT,
    CONSTRAINT fk_harv_plant FOREIGN KEY (plantation_id)
        REFERENCES Plantation(plantation_id) ON DELETE CASCADE
);

CREATE TABLE Sales (
    sale_id          INT AUTO_INCREMENT PRIMARY KEY,
    harvest_id       INT NOT NULL,
    buyer_name       VARCHAR(100),
    quantity_sold_kg DECIMAL(10,2),
    price_per_kg     DECIMAL(8,2),
    sale_date        DATE,
    total_amount     DECIMAL(12,2) GENERATED ALWAYS AS
                     (quantity_sold_kg * price_per_kg) STORED,
    CONSTRAINT fk_sale_harv FOREIGN KEY (harvest_id)
        REFERENCES Harvests(harvest_id) ON DELETE CASCADE
);

CREATE TABLE Disease (
    disease_id     INT AUTO_INCREMENT PRIMARY KEY,
    crop_id        INT NOT NULL,
    disease_name   VARCHAR(100),
    detection_date DATE,
    severity       VARCHAR(20),
    treatment      TEXT,
    CONSTRAINT fk_dis_crop FOREIGN KEY (crop_id)
        REFERENCES Crops(crop_id) ON DELETE CASCADE
);

INSERT INTO Farmers (full_name, contact_no, address) VALUES
('Ali Hassan',   '0300-1234567', 'Village Ravi, Lahore'),
('Sara Khan',    '0321-9876543', 'Bhalwal, Sargodha'),
('Usman Tariq',  '0311-5554433', 'Chichawatni, Sahiwal'),
('Bilal Ahmed',  '0333-7778899', 'Multan Road, Bahawalpur'),
('Fatima Malik', '0345-1122334', 'Gujranwala');

INSERT INTO Farms (farmer_id, farm_name, location, area_acres, soil_type) VALUES
(1, 'Ali Farm 1',    'Ravi Road, Lahore',    12.5, 'Clay Loam'),
(1, 'Ali Farm 2',    'Sheikhupura',           8.0, 'Sandy'),
(2, 'Sara Land',     'Bhalwal, Sargodha',    20.0, 'Alluvial'),
(3, 'Usman Fields',  'Sahiwal District',     15.0, 'Loamy'),
(4, 'Bilal Orchard', 'Bahawalpur',           10.0, 'Sandy Loam'),
(5, 'Fatima Farm',   'Gujranwala District',  18.0, 'Clay');

INSERT INTO Crops (crop_name, season, duration_days) VALUES
('Wheat',     'Rabi',   120),
('Rice',      'Kharif', 150),
('Cotton',    'Kharif', 180),
('Tomato',    'Rabi',    90),
('Maize',     'Kharif', 100),
('Sugarcane', 'Kharif', 365);

INSERT INTO Plantation (farm_id, crop_id, planting_date, expected_harvest, status) VALUES
(1, 1, '2025-11-01', '2026-03-01', 'Active'),
(1, 4, '2025-11-15', '2026-02-15', 'Active'),
(3, 2, '2025-06-01', '2025-11-01', 'Harvested'),
(4, 3, '2025-05-15', '2025-11-15', 'Active'),
(5, 5, '2025-07-01', '2025-10-10', 'Harvested'),
(6, 6, '2025-03-01', '2026-03-01', 'Active');

INSERT INTO Irrigation (plantation_id, method, frequency_days, last_irrigated, water_source) VALUES
(1, 'Drip',      7,  '2025-12-01', 'Canal'),
(2, 'Flood',     5,  '2025-12-03', 'Tubewell'),
(3, 'Sprinkler', 10, '2025-10-20', 'Canal'),
(4, 'Flood',     6,  '2025-11-25', 'River'),
(6, 'Drip',      4,  '2025-12-05', 'Canal');

INSERT INTO Fertilizers (fertilizer_name, type, npk_ratio) VALUES
('Urea', 'Nitrogenous', '46-0-0'),
('DAP',  'Phosphatic',  '18-46-0'),
('SOP',  'Potassic',    '0-0-50'),
('CAN',  'Nitrogenous', '27-0-0'),
('SSP',  'Phosphatic',  '0-18-0');

INSERT INTO Crop_Fertilizer (crop_id, fertilizer_id, application_date, quantity_kg) VALUES
(1, 1, '2025-12-01', 50.0),
(1, 2, '2025-12-15', 30.0),
(2, 1, '2025-07-01', 40.0),
(2, 3, '2025-08-01', 25.0),
(3, 2, '2025-06-01', 35.0),
(4, 5, '2025-11-20', 15.0);

INSERT INTO Harvests (plantation_id, harvest_date, quantity_kg, quality_grade, notes) VALUES
(1, '2026-03-05', 4500.00, 'A',  'Excellent yield this season'),
(2, '2026-02-20', 1200.00, 'B',  'Slight pest damage'),
(3, '2025-11-05', 6200.00, 'A+', 'Best yield in 3 years'),
(5, '2025-10-12', 3100.00, 'B+', 'Good quality maize');

INSERT INTO Sales (harvest_id, buyer_name, quantity_sold_kg, price_per_kg, sale_date) VALUES
(1, 'Ahmed Traders',     3000.00, 45.00, '2026-03-10'),
(1, 'Punjab Flour Mill', 1000.00, 46.00, '2026-03-15'),
(2, 'Local Market',       800.00, 80.00, '2026-02-25'),
(3, 'Bashir Rice Co.',   5000.00, 55.00, '2025-11-10'),
(4, 'Karachi Buyers',    2500.00, 30.00, '2025-10-18');

INSERT INTO Disease (crop_id, disease_name, detection_date, severity, treatment) VALUES
(4, 'Tomato Blight',    '2025-12-20', 'High',   'Spray Mancozeb fungicide every 7 days'),
(1, 'Wheat Rust',       '2025-12-10', 'Medium', 'Apply Propiconazole fungicide'),
(2, 'Rice Blast',       '2025-08-15', 'Low',    'Use resistant variety, apply Tricyclazole'),
(3, 'Cotton Leaf Curl', '2025-07-01', 'High',   'Control whitefly with Imidacloprid');

INSERT INTO Farmers (full_name, contact_no, address)
VALUES ('Hamza Riaz', '0312-4567890', 'Faisalabad');

INSERT INTO Farms (farmer_id, farm_name, location, area_acres, soil_type)
VALUES (1, 'Ali Farm 3', 'Kasur Road, Lahore', 5.5, 'Alluvial');

INSERT INTO Plantation (farm_id, crop_id, planting_date, expected_harvest, status)
VALUES (2, 5, '2025-07-10', '2025-10-20', 'Active');

SELECT
    f.farm_name,
    c.crop_name,
    p.planting_date,
    p.expected_harvest,
    p.status
FROM Plantation p
JOIN Farms f ON p.farm_id = f.farm_id
JOIN Crops c ON p.crop_id = c.crop_id
WHERE f.farm_id = 1
ORDER BY p.planting_date;

SELECT * FROM Irrigation WHERE irrigation_id = 1;

UPDATE Irrigation
SET
    frequency_days = 10,
    last_irrigated = '2025-12-15',
    method = 'Sprinkler'
WHERE irrigation_id = 1;

SELECT * FROM Irrigation WHERE irrigation_id = 1;

INSERT INTO Crop_Fertilizer (crop_id, fertilizer_id, application_date, quantity_kg)
VALUES (1, 3, '2026-01-10', 20.0);

SELECT
    c.crop_name,
    f.fertilizer_name,
    f.type,
    f.npk_ratio,
    cf.application_date,
    cf.quantity_kg
FROM Crop_Fertilizer cf
JOIN Crops       c ON cf.crop_id       = c.crop_id
JOIN Fertilizers f ON cf.fertilizer_id = f.fertilizer_id
WHERE c.crop_name = 'Wheat';

INSERT INTO Harvests (plantation_id, harvest_date, quantity_kg, quality_grade, notes)
VALUES (4, '2025-11-20', 5500.00, 'A', 'Good cotton harvest, minimal pest damage');

INSERT INTO Sales (harvest_id, buyer_name, quantity_sold_kg, price_per_kg, sale_date)
VALUES (5, 'Lahore Textile Mill', 2000.00, 120.00, '2025-11-25');

SELECT
    f.farm_name,
    f.location,
    COUNT(s.sale_id)             AS total_sales,
    SUM(s.quantity_sold_kg)      AS total_kg_sold,
    SUM(s.total_amount)          AS total_revenue_pkr
FROM Sales s
JOIN Harvests   h ON s.harvest_id    = h.harvest_id
JOIN Plantation p ON h.plantation_id = p.plantation_id
JOIN Farms      f ON p.farm_id       = f.farm_id
GROUP BY f.farm_id, f.farm_name, f.location
ORDER BY total_revenue_pkr DESC;

INSERT INTO Disease (crop_id, disease_name, detection_date, severity, treatment)
VALUES (5, 'Maize Stem Borer', '2025-09-01', 'Medium', 'Apply Chlorpyrifos insecticide');

SELECT
    c.crop_name,
    c.season,
    d.disease_name,
    d.detection_date,
    d.severity,
    d.treatment
FROM Disease d
JOIN Crops c ON d.crop_id = c.crop_id
ORDER BY d.detection_date DESC;

SELECT
    fa.full_name                       AS farmer,
    fm.farm_name                       AS farm,
    c.crop_name                        AS crop,
    p.planting_date,
    p.status,
    IFNULL(h.quantity_kg, 0)           AS harvested_kg,
    IFNULL(h.quality_grade, 'N/A')     AS grade
FROM Plantation p
JOIN Farms   fm ON p.farm_id    = fm.farm_id
JOIN Farmers fa ON fm.farmer_id = fa.farmer_id
JOIN Crops   c  ON p.crop_id   = c.crop_id
LEFT JOIN Harvests h ON h.plantation_id = p.plantation_id
ORDER BY fa.full_name, p.planting_date;

SELECT
    fm.farm_name,
    c.crop_name,
    p.planting_date,
    p.expected_harvest,
    DATEDIFF(p.expected_harvest, CURDATE()) AS days_remaining
FROM Plantation p
JOIN Farms fm ON p.farm_id = fm.farm_id
JOIN Crops c  ON p.crop_id = c.crop_id
WHERE p.status = 'Active'
ORDER BY p.expected_harvest;

SELECT
    fa.full_name,
    fa.contact_no,
    COUNT(fm.farm_id)  AS total_farms,
    SUM(fm.area_acres) AS total_acres
FROM Farmers fa
LEFT JOIN Farms fm ON fa.farmer_id = fm.farmer_id
GROUP BY fa.farmer_id, fa.full_name, fa.contact_no
ORDER BY total_acres DESC;

DELETE FROM Plantation
WHERE plantation_id = 6
  AND status = 'Active';

CREATE USER 'farm_viewer'@'localhost' IDENTIFIED BY 'ViewPass123';
GRANT SELECT ON farm_management.* TO 'farm_viewer'@'localhost';

CREATE USER 'farm_operator'@'localhost' IDENTIFIED BY 'OpPass456';
GRANT SELECT, INSERT, UPDATE ON farm_management.* TO 'farm_operator'@'localhost';

REVOKE DELETE ON farm_management.* FROM 'farm_operator'@'localhost';

SHOW GRANTS FOR 'farm_viewer'@'localhost';
SHOW GRANTS FOR 'farm_operator'@'localhost';
