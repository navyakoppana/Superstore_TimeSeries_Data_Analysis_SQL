# Superstore_TimeSeries_Data_Analysis_SQL
## Table of Contents
1. Overview
2. Files in the repository
3. Summary of the analysis
4. Acknowledgements

### Overview
Time series data is a collection of variables whose values depend on time. This project mostly makes use of WINDOW functions in sql to perform analysis.

### Files in the repository
a. superstoredata.csv: This file has a dataset containing 20 columns, namely, Row ID, Order ID, Order Date, Ship Date, Ship Mode, Customer ID, Customer Name, Segment, Country, City,Sales,Quantity etc.
b. test_result.csv: This file contains profit corresponding to row_id.
c. superstore_analysis.sql: This contains all the steps involved in analysis from preprocessing data to querying the data using PostgreSQL.

### Summary of the analysis
1. Various WINDOW functions like LEAD(),LAG(),RANK() are used in querying the data.
2. Consumer segment has the highest sales.
3. June month has the highest monthly average sales.
4. Phones under Technology in West region are the highest revenue generators.
5. Canon imageCLASS 2200 Advanced Copier is the highest sold product.
6. Acco Suede Grain Vinyl Round Ring Binder is the lowest sold product.
7. California is the state with highest number of orders.
8. Almost 60% of orders are of 'Standard Class' shipment.
9. Around 5% of orders are shipped on the same day as order date.

### Acknowledgements
The dataset is taken from Kaggle <a href="https://www.kaggle.com/datasets/blurredmachine/superstore-time-series-dataset">Superstore_timeseries_data</a>
