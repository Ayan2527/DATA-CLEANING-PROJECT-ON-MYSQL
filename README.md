# MySQL Data Cleaning Project

## Overview
This project focuses on cleaning and standardizing data in a MySQL table named `layoffs`. The tasks include removing duplicates, standardizing date formats, handling null values, and correcting inconsistent data entries to ensure the data is accurate and ready for analysis.

## Prerequisites
- MySQL server
- MySQL Workbench or any MySQL client
- Basic knowledge of SQL

## Setup
1. **Clone the Repository:**
    ```bash
    git clone https://github.com/yourusername/mysql-data-cleaning.git
    cd mysql-data-cleaning
    ```
2. **Import the Database:**
    - Open MySQL Workbench.
    - Create a new schema or use an existing one.
    - Import your database dump.

## Data Cleaning Steps
1. **Create a Staging Table:**
   - Make a copy of the raw data to ensure the original data remains unaltered.

2. **Remove Duplicates:**
   - Identify and remove duplicate records by creating a unique row identifier.

3. **Standardize Dates:**
   - Convert all dates to a consistent format.

4. **Handle Null Values:**
   - Identify and fill or remove null values as appropriate.

5. **Correct Inconsistent Data:**
   - Standardize entries for fields like `industry` and `country` to ensure consistency.

6. **Remove Unnecessary Columns:**
   - Drop columns that are not needed for analysis.

## Usage
- Open MySQL Workbench and connect to your MySQL server.
- Run the provided SQL scripts to clean the data.
- Verify the changes by querying the `layoffs_stagging` table.

## Contributing
1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Commit and push your changes.
5. Open a Pull Request.

