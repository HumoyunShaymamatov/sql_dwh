/*
===========================================================
Procedure: bronze.load_bronze
Purpose: Load raw data into bronze layer tables from CSV files.

Description:
This stored procedure performs full reloads of all bronze
tables by truncating existing data and bulk inserting fresh
data from CRM and ERP source files. It is intended to be the
first step in the ETL pipeline.

Key Features:
- Uses BULK INSERT for fast, efficient loading of large files
- Fully reloads tables (TRUNCATE + INSERT) to ensure consistency
- Separates CRM and ERP loads for clarity and maintainability
- Measures and prints load duration per table and total runtime
- Includes TRY/CATCH error handling for easier troubleshooting
- Uses TABLOCK to improve bulk insert performance

Usage:
EXEC bronze.load_bronze;

Notes:
- Source file paths must be accessible by SQL Server
- Intended for staging raw data before transformation to silver layer
- Typically executed manually, via SQL Agent, or ETL orchestration tool
===========================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start DATETIME, @end DATETIME;
	SET @start = GETDATE()

	BEGIN TRY
		PRINT '============================================================================';
		PRINT 'Loading the BRONZE Layer';
		PRINT '============================================================================';

		PRINT '_____________________________________________________________________';
		PRINT 'Loading CRM Tables';

		SET @start_time = GETDATE()
		PRINT '>> TRUNCATING crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> INSERTING data into: crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Legion\OneDrive\Desktop\DataWarehousing\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-----------------'

		SET @start_time = GETDATE()
		PRINT '>> TRUNCATING crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> INSERTING data into: crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Legion\OneDrive\Desktop\DataWarehousing\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-----------------'

		SET @start_time = GETDATE()
		PRINT '>> TRUNCATING crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> INSERTING data into: crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Legion\OneDrive\Desktop\DataWarehousing\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-----------------'

		PRINT '_____________________________________________________________________';
		PRINT 'Loading ERP Tables';

		SET @start_time = GETDATE()
		PRINT '>> TRUNCATING erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> INSERTING data into: erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Legion\OneDrive\Desktop\DataWarehousing\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-----------------'

		SET @start_time = GETDATE()
		PRINT '>> TRUNCATING erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> INSERTING data into: erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Legion\OneDrive\Desktop\DataWarehousing\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-----------------'

		SET @start_time = GETDATE()
		PRINT '>> TRUNCATING erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> INSERTING data into: erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Legion\OneDrive\Desktop\DataWarehousing\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '============================================================================';
	END TRY

	BEGIN CATCH
		PRINT '============================================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '============================================================================';
	END CATCH

	SET @end = GETDATE()
	PRINT 'Total Duration: ' + CAST(DATEDIFF(second, @start, @end) AS NVARCHAR) + ' seconds.'
END;
