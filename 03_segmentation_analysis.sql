-- 03_segmentation_analysis.sql
-- Goal: Assign "Human Readable" segments to customers based on RFM scores.

WITH rfm_metrics AS (
    SELECT
        customer_id,
        DATE_PART('day', '2018-10-18'::timestamp - MAX(order_purchase_timestamp)) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(total_spend) AS monetary
    FROM
        analytics_base_table
    GROUP BY
        customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM
        rfm_metrics
),

segmented_data AS (
    SELECT
        customer_id,
        r_score,
        f_score,
        m_score,
        monetary,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'
            WHEN m_score = 5 AND f_score < 5 THEN 'Whales'
            WHEN r_score >= 4 AND f_score = 1 THEN 'New Customers'
            WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
            WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
            ELSE 'Regulars'
        END AS segment
    FROM
        rfm_scores
)

-- Final Output for Dashboard
-- Returns the count of users and average spend per segment
SELECT 
    segment,
    COUNT(*) AS total_users,
    ROUND(AVG(monetary), 2) AS avg_spend,
    SUM(monetary) AS total_revenue
FROM
    segmented_data
GROUP BY
    1
ORDER BY
    total_revenue DESC;