/*
===========================================================
DataWarehouse Initialization Script
Purpose: Recreate DataWarehouse database and core schemas
WARNING: This will DROP the existing DataWarehouse database
===========================================================
*/

USE master;
GO

-- Drop existing DataWarehouse database if it exists
-- Force disconnect all users to avoid drop failure
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse 
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END;
GO

-- Create fresh DataWarehouse database
CREATE DATABASE DataWarehouse;
GO

-- Switch to DataWarehouse context
USE DataWarehouse;
GO

-- Create schemas for Medallion Architecture
-- bronze: raw source data
CREATE SCHEMA bronze;
GO

-- silver: cleaned and transformed data
CREATE SCHEMA silver;
GO

-- gold: business-ready data for reporting
CREATE SCHEMA gold;
GO