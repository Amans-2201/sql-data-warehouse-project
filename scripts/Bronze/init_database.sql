/*
==========================================================================================
Create DataWarehouse Database and Schemas
==========================================================================================
Script Purpose:
 This script initializes the DataWarehouse database by checking for its existence,
 dropping it if it exists, and then creating the database along with the necessary schemas.   
 
⚠️Warning: This script will drop the existing DataWarehouse database if it exists,   
 and all data within it will be lost.
⚠️Use with caution:
 Ensure you have the necessary permissions to create and drop databases
 */
-- Set the context to the master database to ensure we can create a new database.

USE master;

GO
-- Check if the DataWarehouse database exists. If it does, no action is taken.
IF  EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    Alter Database DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the DataWarehouse database.
CREATE DATABASE DataWarehouse;
GO

-- Switch to the newly created DataWarehouse database.

USE DataWarehouse;
-- Note: After creating the database, subsequent commands to create schemas
GO

-- Create the bronze schema.
-- The bronze schema is typically used for storing raw data ingested from source systems
-- with minimal or no transformations.
CREATE SCHEMA bronze;
GO

-- Create the silver schema.
-- The silver schema is used for storing data that has been cleansed, conformed,
-- and integrated from the bronze layer. Data here is often queryable and validated.
CREATE SCHEMA silver;
GO

-- Create the gold schema.
-- The gold schema contains highly refined, aggregated, and business-specific data.
-- It's optimized for reporting, analytics, and end-user consumption.
CREATE SCHEMA gold;
