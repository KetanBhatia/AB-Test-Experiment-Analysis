
-- ==========================================
-- A/B TEST AND EXPERIMENT ANALYSIS
-- PostgreSQL SQL Analysis
-- Dataset: ab_data_cleaned.csv
-- ==========================================

-- 1. Total number of users
SELECT COUNT(*) AS total_users
FROM ab_test;


-- 2. Users in each experiment group
SELECT
    "group",
    COUNT(*) AS total_users
FROM ab_test
GROUP BY "group"
ORDER BY "group";


-- 3. Conversion rate by group
SELECT
    "group",
    COUNT(*) AS total_users,
    SUM(converted) AS total_conversions,
    ROUND(
        AVG(converted::numeric) * 100,
        4
    ) AS conversion_rate_pct
FROM ab_test
GROUP BY "group"
ORDER BY "group";


-- 4. Absolute and relative lift
WITH conversion_rates AS (
    SELECT
        "group",
        AVG(converted::numeric) AS conversion_rate
    FROM ab_test
    GROUP BY "group"
)
SELECT
    ROUND(
        (t.conversion_rate - c.conversion_rate) * 100,
        4
    ) AS absolute_lift_pp,
    ROUND(
        (t.conversion_rate - c.conversion_rate)
        / NULLIF(c.conversion_rate, 0) * 100,
        4
    ) AS relative_lift_pct
FROM conversion_rates c
CROSS JOIN conversion_rates t
WHERE c."group" = 'control'
  AND t."group" = 'treatment';


-- 5. Daily conversion trends
SELECT
    "timestamp"::date AS test_date,
    "group",
    COUNT(*) AS total_users,
    SUM(converted) AS total_conversions,
    ROUND(
        AVG(converted::numeric) * 100,
        2
    ) AS conversion_rate_pct
FROM ab_test
GROUP BY
    "timestamp"::date,
    "group"
ORDER BY
    test_date,
    "group";


-- 6. Cumulative conversion rates
WITH daily_data AS (
    SELECT
        "timestamp"::date AS test_date,
        "group",
        COUNT(*) AS total_users,
        SUM(converted) AS conversions
    FROM ab_test
    GROUP BY
        "timestamp"::date,
        "group"
)
SELECT
    test_date,
    "group",
    SUM(total_users) OVER (
        PARTITION BY "group"
        ORDER BY test_date
    ) AS cumulative_users,
    SUM(conversions) OVER (
        PARTITION BY "group"
        ORDER BY test_date
    ) AS cumulative_conversions,
    ROUND(
        100.0 * SUM(conversions) OVER (
            PARTITION BY "group"
            ORDER BY test_date
        )
        /
        SUM(total_users) OVER (
            PARTITION BY "group"
            ORDER BY test_date
        ),
        2
    ) AS cumulative_conversion_rate_pct
FROM daily_data
ORDER BY test_date, "group";

