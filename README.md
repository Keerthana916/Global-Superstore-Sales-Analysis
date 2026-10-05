#  Global Superstore Sales & Business Intelligence Analysis

An end-to-end data analytics project exploring the Global Superstore dataset. This project covers the entire data lifecycle—from raw data extraction and domain analysis, through Python preprocessing and SQL relational modeling, to Power BI dashboarding and final strategic business recommendations.

---

##  Repository Structure

```text
Global-Superstore-Sales-Analysis/
│
├── README.md                                  # Project overview and documentation
├── 1_Raw_Data/                                # Original raw dataset files (CSV/Excel)
├── 2_Domain_Analysis/                         # Business problem statement and objectives
├── 3_Python_Scripts/                          # Jupyter Notebooks for data preprocessing and EDA
├── 4_SQL_Scripts/                             # MySQL scripts (Star Schema, DDL, DML, advanced queries)
├── 5_PowerBI_Dashboard/                       # Dashboard files (.pbix) and visual exports
└── 6_Insights_and_Recommendations/           # Detailed business reports and findings
```


## Project Overview & Key Matrices

* **Total Sales :** $12.64M
* **Total Profit :** $1.47M
* **Total Quantity Sold :** 178,312 units
* **Overall Profit Margin :** 11.61%


## Workflow Summary

1. **Raw Data & Domain Analysis :** Understanding business requirements, mapping out schema needs, and inspecting data integrity.
2. **Python Preprocessing & EDA :** Handling data cleaning, missing values, and exploratory data analysis using Python and pandas.
3. **Advanced SQL Analysis :** Leveraging window functions (RANK(), LAG(), running totals) to year-over-year growth, products rankings, and customer segmentation.
4. **SQL Relational Modelling (Star Schema) :** Transforming flat data into a clean dimensional model consisting of:
          * Dim_Customer
          * Dim_Product (with surrogate Product_Key)
          * Dim_Date (generated via recursive CTEs spanning 2011-2014)
          * Dim_Geography
          * Fact_Sales (with Foreign Key constraints)
5. **Power BI Dashboards :** Building interactive visuals to track regional contributions, category splits, and monthly seasonality trends


## Key Insights

* **Category Revenue vs. Margin Divergence :** Technology leads total sales at 37.53%, while Furniture commands high sales volume (~32%) but suffers from weak profit margin due to high overheads and discounts.
* **The Discount Trap :** Heavy discounting (specially above 20% threshold) aggressively erodes margins, turning high-volume sub-categories like Tables into net-loss drivers.
* **Regional & Customer Disconnects :** High-revenue regions (Central, South, North) and high-volume customers accounts do not always correlate with top profit efficiency proving that top-line sales alone mask underlying margin leakage.
* **Seasonal Demand Spikes :** Longitudinal trends show steady year-over-year expansion (~26%-27%), driven primarily by order frequency surges during Q4 (November/ December).


## Business Recommendations

1. **Controls Heavy Discounts :** Avoid offering discounts above 20% on vulnerable product categories where profit margin quickely disappear.
2. **Shift to Margin-Weighted Management :** Capitalize on high-margin Technology lines while re-engineering cost structures for low-margin Furniture categories.
3. **Audit Regional Logistics :** Investigate high-sales/ low-profit territories to identify localized shipping friction or excessive markdown policies.
4. **Redefine High-Value Customer Metrics :** Re-evaluate high-volume accounts that currently register net losses by adjusting their pricing terms and maximum markdown allowances. 


## Tech Stack

* **Languages & Tools :** Python(Pandas, Jupyter), SQL(MySQL), Power BI
* **Conepts :** Star Schema Design, Data Cleaning, Exploratory Data Analysis, Window Functions, Business Intelligence Reporting


