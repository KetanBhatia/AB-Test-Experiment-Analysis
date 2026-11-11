
CREATE TABLE ab_test (
    user_id BIGINT,
    "timestamp" TIMESTAMP,
    "group" VARCHAR(20),
    landing_page VARCHAR(20),
    converted INTEGER
);



SELECT COUNT(*)
FROM ab_test;



SELECT
    "group",
    COUNT(*) AS total_users
FROM ab_test
GROUP BY "group";




SELECT
    "group",
    COUNT(*) AS total_users,
    SUM(converted) AS total_conversions,
    ROUND(AVG(converted) * 100, 4) AS conversion_rate
FROM ab_test
GROUP BY "group";





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
        ((t.conversion_rate - c.conversion_rate)
        / NULLIF(c.conversion_rate, 0)) * 100,
        4
    ) AS relative_lift_pct

FROM conversion_rates c
CROSS JOIN conversion_rates t
WHERE c."group" = 'control'
  AND t."group" = 'treatment';



  
SELECT
    "timestamp"::date AS test_date,
    "group",
    COUNT(*) AS total_users,
    SUM(converted) AS total_conversions,
    ROUND(AVG(converted::numeric) * 100, 2) AS conversion_rate
FROM ab_test
GROUP BY
    "timestamp"::date,
    "group"
ORDER BY
    test_date,
    "group";




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
    ) AS cumulative_conversion_rate

FROM daily_data
ORDER BY test_date, "group";



