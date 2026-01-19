-- 02_rfm_calculation.sql
-- Goal: Calculate Recency, Frequency, and Monetary (RFM) metrics.
-- Technique: Uses NTILE(5) window function to score users on a curve.

-- Step 1: Calculate Raw Metrics
WITH rfm_metrics AS (
    SELECT
        customer_id,
        -- Recency: Days since '2018-10-18' (Simulation of analysis date)
        DATE_PART('day', '2018-10-18'::timestamp - MAX(order_purchase_timestamp)) AS recency,
        -- Frequency: Total unique orders
        COUNT(DISTINCT order_id) AS frequency,
        -- Monetary: Total spend
        SUM(total_spend) AS monetary
    FROM
        analytics_base_table
    GROUP BY
        customer_id
)

-- Step 2: Assign Scores (1-5)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    -- Recency: Lower is better (1 day ago = Score 5)
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    -- Frequency: Higher is better
    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
    -- Monetary: Higher is better
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
FROM
    rfm_metrics;