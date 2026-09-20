

/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Purpose:
    This script creates all Bronze-layer tables required for the data warehouse.

    Existing tables are dropped and recreated to ensure the latest schema
    definition is applied during deployment.

Layer:
    Bronze

Source Systems:
    - CRM
    - ERP

Notes:
    - Bronze tables store raw data as received from source systems.
    - No cleansing, transformation, or business rules are applied at this stage.
    - These tables serve as the foundation for downstream Silver-layer
      processing.

Warning:
    Executing this script will permanently remove existing data from the
    target Bronze tables before recreating them.
===============================================================================
*/


/*
===============================================================================
CRM TABLES
===============================================================================

Tables:
    1. crm_cust_info      - Customer master data
    2. crm_prd_info       - Product master data
    3. crm_sales_details  - Sales transaction data
===============================================================================
*/

/*
===============================================================================
Table: bronze.crm_cust_info
===============================================================================
Description:
    Stores customer master data extracted from the CRM source system.

Business Purpose:
    Contains customer attributes such as name, gender, marital status,
    and account creation date.

Usage:
    Used as the primary source for customer-related transformations in
    downstream Silver and Gold layers.
===============================================================================
*/

-- Drop table if it already exists to ensure a clean recreation.
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

-- Create Bronze customer master table.
CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
);
GO


/*
===============================================================================
Table: bronze.crm_prd_info
===============================================================================
Description:
    Stores product master data extracted from the CRM source system.

Business Purpose:
    Contains product information including product name, product line,
    cost, and product lifecycle dates.

Usage:
    Forms the foundation for product dimension creation and reporting.
===============================================================================
*/

-- Drop table if it already exists to ensure a clean recreation.
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

-- Create Bronze product master table.
CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
GO


/*
===============================================================================
Table: bronze.crm_sales_details
===============================================================================
Description:
    Stores raw sales transaction records extracted from the CRM source
    system.

Business Purpose:
    Captures customer purchases, product references, quantities sold,
    order dates, shipping dates, due dates, and sales amounts.

Usage:
    Serves as the primary transactional fact source for sales analytics.

Notes:
    Date fields are currently stored using the source-system format and
    will be standardized during Silver-layer processing.
===============================================================================
*/

-- Drop table if it already exists to ensure a clean recreation.
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

-- Create Bronze sales transaction table.
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);
GO


/*
===============================================================================
ERP TABLES
===============================================================================

Tables:
    1. erp_loc_a101      - Customer location information
    2. erp_cust_az12     - Customer demographic information
    3. erp_px_cat_g1v2   - Product category information
===============================================================================
*/

/*
===============================================================================
Table: bronze.erp_loc_a101
===============================================================================
Description:
    Stores customer geographic information from the ERP source system.

Business Purpose:
    Provides country-level location attributes associated with customers.

Usage:
    Used for customer segmentation and geographic reporting.
===============================================================================
*/

-- Drop table if it already exists to ensure a clean recreation.
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

-- Create Bronze customer location table.
CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50)
);
GO


/*
===============================================================================
Table: bronze.erp_cust_az12
===============================================================================
Description:
    Stores customer demographic information from the ERP source system.

Business Purpose:
    Contains customer birth date and gender attributes.

Usage:
    Supports customer profiling and demographic analysis.
===============================================================================
*/

-- Drop table if it already exists to ensure a clean recreation.
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

-- Create Bronze customer demographic table.
CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50)
);
GO


/*
===============================================================================
Table: bronze.erp_px_cat_g1v2
===============================================================================
Description:
    Stores product categorization data from the ERP source system.

Business Purpose:
    Maps products to categories, subcategories, and maintenance groups.

Usage:
    Supports product hierarchy reporting and analytical modeling.
===============================================================================
*/

-- Drop table if it already exists to ensure a clean recreation.
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

-- Create Bronze product category table.
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);
GO