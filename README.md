# Olist Marketing Analytics: RFM Customer Segmentation
**Turning "Spray and Pray" Marketing into a Precision Revenue Engine.**

Automated customer segmentation engine built with SQL. Identifies high-value "Champions" and "At-Risk" users to drive retention strategies.

To ensure a structured, end-to-end analysis, this project follows the **Google Data Analytics 6-Step Framework** (Ask, Prepare, Process, Analyze, Share, Act), guiding the workflow from the initial business question to strategic execution.

## 1. Ask
**The Client:** Olist (Brazilian E-Commerce Marketplace).

**The Stakeholder:** Chief Marketing Officer (CMO).

**The Business Problem:** The marketing team currently utilizes a "spray and pray" approach, allocating the same ad budget to every customer regardless of their value or behavior. They lack visibility into which customers are profitable, leading to wasted spend on one-time buyers and missed opportunities to retain high-value VIPs.

**The Goal:** Build an automated **RFM (Recency, Frequency, Monetary) Segmentation Engine** to identify distinct customer personas. The objective is to prescribe targeted marketing strategies for each group to reduce churn, increase retention, and maximize ROI.

## 2. Prepare
**Data Source:** [Olist E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (90k+ anonymized orders from 2016-2018).

**Tech Stack:**
* **Database:** PostgreSQL (Localhost)
* **Analysis:** SQL (Window Functions, CTEs, Views)
* **Visualization:** Tableau

## 3. Process
**Step 1: Data Engineering & Cleaning**
The raw data was fragmented across three separate tables (`orders`, `payments`, `items`). Initial profiling revealed data integrity issues, including "Ghost Revenue" (orders that were canceled or unavailable) and duplicate records caused by 1-to-many payment joins.

**Action:** I constructed a robust data pipeline to clean and merge these sources. I created a "Single Source of Truth" view (`analytics_base_table`) that strictly filters for delivered orders and pre-aggregates payments to ensure accurate revenue reporting.

## 4. Analyze
**Step 2: Feature Engineering (RFM)**
I calculated the core marketing metrics for each of the 90,000+ customers using a "Frozen Date" approach (simulating the analysis as if it were run the day after the dataset ends) to prevent recency bias.
* **Recency:** Days since last purchase.
* **Frequency:** Count of unique orders.
* **Monetary:** Total lifetime spend.

**Key Technique:** I used `NTILE(5)` Window Functions to grade customers on a curve from 1-5, allowing for dynamic scoring rather than static thresholds.

**Step 3: Segmentation Logic**
Rather than simply summing the RFM scores (which loses detail), I used a layered `CASE` statement to map specific score combinations to human-readable "Personas." This allows the Marketing Director to instantly understand the behavioral profile and trends of each group.

| Segment Name | Description | Logic (RFM Score) |
| :--- | :--- | :--- |
| **🏆 Champions** | Your absolute best customers. They bought recently, buy often, and spend the most. | R=5, F=5, M=5 |
| **🐳 Whales** | High-ticket shoppers who spend a lot but don't buy often (e.g., Bought a TV, then vanished). | M=5, F=1-2 |
| **❤️ Loyal Customers** | Reliable repeat buyers. They might not be the biggest spenders, but they are consistent and active. | R=3-5, F=3-5 |
| **🌱 New Customers** | Customers who just made their first purchase. They are in the "Honeymoon Phase." | R=5, F=1 |
| **🧊 At Risk** | Former high-value customers who stopped buying long ago. There is still hope to win them back. | R=1-2, F/M=High |
| **👻 Lost** | One-time buyers from long ago who spent little. Likely not worth the ad spend to re-acquire. | R=1, F=1, M=1 |

## 5. Share
### Diagnostic & Prioritization
Now let's observe specific business vulnerabilities of each group. Instead of fixing everything at once, we assigned a **Strategic Priority** to determine actions step by step. The top priority of the project is to stop the biggest bleeding point and eliminate further money leakage.

1.  **At Risk (Priority 1):** *Churn Risk.* These are proven high-value buyers who haven't visited in months. We are about to lose them, and they are the biggest group by user count (22,617).
2.  **New Customers (Priority 2):** *Fragility.* They made one purchase but haven't established loyalty. If we don't get a 2nd order in 30 days, they usually churn. They didn't spend much yet, but we need to encourage them to make another purchase.
3.  **Whales (Priority 2):** *Low Frequency.* They treat Olist like a specific appliance store (one-off purchase) rather than a lifestyle marketplace. We should show more opportunities in the market.
4.  **Champions (Priority 3):** *Margin Erosion.* We are currently targeting them with generic discount codes, losing money on sales they would have made anyway. We need to find other marketing offers for them.
5.  **Loyal Customers (Priority 3):** *Stagnation.* They are consistent but their basket size is small. They need a push to spend more.
6.  **Lost (Priority 4):** *Dead Weight.* Low recency, low spend. Marketing to them costs more than the revenue they generate. The least priority group.

## 6. Act
### Strategic Implementation
Based on the roadmap above, here is the tailored marketing action plan for each segment.

**Step 1: Stop the Churn**
* **Target:** At Risk
* **Strategy:** Aggressive Resurrection.
* **Action:** Send high-value incentives (15% OFF or "Free Shipping on Next Order").
* **Why:** The cost of re-activating a dormant high-value user is significantly lower than acquiring a new one. We sacrifice margin to win back the customer lifetime value (LTV).

**Step 2: Drive Growth (The "Habit" Campaign)**
* **Part 1 - Target:** New Customers
    * **Strategy:** Onboarding & Trust.
    * **Action:** Send a "Welcome Series" containing social proof (reviews) and a time-sensitive coupon for the second purchase only.
* **Part 2 - Target:** Whales
    * **Strategy:** Cross-Category Expansion.
    * **Action:** If they bought a PC, wait 14 days and recommend "Top Rated Office Chairs." Do not show them low-ticket generic items.

**Step 3: Optimize Margins (The "VIP" Campaign)**
* **Part 1 - Target:** Champions
    * **Strategy:** Exclusivity over Discounts.
    * **Action:** Remove them from standard discount blasts. Grant "Beta Tester" access to new features or "Early Access" to Black Friday sales.
* **Part 2 - Target:** Loyal Customers
    * **Strategy:** Upselling (Basket Building).
    * **Action:** "Bundle & Save" offers. Encourage them to add one more item to reach a higher spending tier.

**Step 4: Clean Up (The "Ignore" List)**
* **Target:** Lost
    * **Strategy:** Suppression.
    * **Action:** Exclude these emails from all paid marketing campaigns to save budget and improve email deliverability rates.
