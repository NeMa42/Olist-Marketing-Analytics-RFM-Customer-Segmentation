# Olist Marketing Analytics RFM Customer Segmentation
Automated customer segmentation engine built with SQL. Identifies high-value "Champions" and "At-Risk" users to drive retention strategies.
Turning "Spray and Pray" Marketing into a Precision Revenue Engine.

To ensure a structured, end-to-end analysis, this project follows the Google Data Analytics 6-Step Framework (Ask, Prepare, Process, Analyze, Share, Act), guiding the workflow from the initial business question to strategic execution.

1. Ask
**The Client**: Olist (Brazilian E-Commerce Marketplace).
**The Stakeholder**: Chief Marketing Officer (CMO).
**The Business Problem**: The marketing team currently utilizes a "spray and pray" approach, allocating the same ad budget to every customer regardless of their value or behavior. They lack visibility into which customers are profitable, leading to wasted spend on one-time buyers and missed opportunities to retain high-value VIPs.
**The Goal**: Build an automated RFM (Recency, Frequency, Monetary) Segmentation Engine to identify distinct customer personas. The objective is to prescribe targeted marketing strategies for each group to reduce churn, increase retention, and maximize ROI.

2. Prepare
**Data Source**: Olist E-Commerce Public Dataset (90k+ anonymized orders from 2016-2018). Tech Stack:
**Database**: PostgreSQL (Localhost)
**Analysis**: SQL (Window Functions, CTEs, Views)
**Visualization**: Tableau

3. Process
**Step 1:** Data Engineering & Cleaning
The raw data was fragmented across three separate tables (orders, payments, items). Initial profiling revealed data integrity issues, including "Ghost Revenue" (orders that were canceled or unavailable) and duplicate records caused by 1-to-many payment joins.
Action: I constructed a robust data pipeline to clean and merge these sources. I created a "Single Source of Truth" view (denormalized_table) that strictly filters for delivered orders and pre-aggregates payments to ensure accurate revenue reporting.



