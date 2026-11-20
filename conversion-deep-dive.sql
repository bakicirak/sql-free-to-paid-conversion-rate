-- ============================================================================
-- Free-to-paid conversion: deep dive (MySQL 8)
-- Goes beyond the headline KPIs in free-to-paid-conversion-rate.sql:
--   1. Time-to-convert distribution (the mean hides a long tail)
--   2. Conversion by "return behaviour" (same-day vs. later first engagement)
--   3. Conversion by registration cohort (month)
-- Population is identical to the headline query: students who watched at
-- least one lecture, excluding students who paid before ever watching.
-- ============================================================================
USE db_course_conversions;

-- Reusable base: one row per engaged student
WITH first_watch AS (
    SELECT student_id, MIN(date_watched) AS first_date_watched
    FROM student_engagement
    GROUP BY student_id
),
first_purchase AS (
    SELECT student_id, MIN(date_purchased) AS first_date_purchased
    FROM student_purchases
    GROUP BY student_id
),
base AS (
    SELECT
        si.student_id,
        si.date_registered,
        fw.first_date_watched,
        fp.first_date_purchased,
        DATEDIFF(fw.first_date_watched, si.date_registered)   AS days_reg_to_watch,
        DATEDIFF(fp.first_date_purchased, fw.first_date_watched) AS days_watch_to_purchase
    FROM student_info si
    JOIN first_watch fw      ON fw.student_id = si.student_id
    LEFT JOIN first_purchase fp ON fp.student_id = si.student_id
    WHERE fp.first_date_purchased IS NULL
       OR fw.first_date_watched <= fp.first_date_purchased
)

-- 1. Time-to-convert distribution among converters
SELECT
    CASE
        WHEN days_watch_to_purchase = 0   THEN '1) same day'
        WHEN days_watch_to_purchase <= 7  THEN '2) 1-7 days'
        WHEN days_watch_to_purchase <= 30 THEN '3) 8-30 days'
        WHEN days_watch_to_purchase <= 90 THEN '4) 31-90 days'
        ELSE                                   '5) 90+ days'
    END                                                         AS time_to_convert,
    COUNT(*)                                                    AS converters,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)          AS pct_of_converters
FROM base
WHERE first_date_purchased IS NOT NULL
GROUP BY time_to_convert
ORDER BY time_to_convert;

-- 2. Conversion rate by how quickly the student first engaged
--    (re-declare the CTEs or wrap them in a view when running statements separately)
WITH first_watch AS (
    SELECT student_id, MIN(date_watched) AS first_date_watched FROM student_engagement GROUP BY student_id
),
first_purchase AS (
    SELECT student_id, MIN(date_purchased) AS first_date_purchased FROM student_purchases GROUP BY student_id
),
base AS (
    SELECT si.student_id, si.date_registered, fw.first_date_watched, fp.first_date_purchased,
           DATEDIFF(fw.first_date_watched, si.date_registered) AS days_reg_to_watch
    FROM student_info si
    JOIN first_watch fw ON fw.student_id = si.student_id
    LEFT JOIN first_purchase fp ON fp.student_id = si.student_id
    WHERE fp.first_date_purchased IS NULL OR fw.first_date_watched <= fp.first_date_purchased
)
SELECT
    CASE
        WHEN days_reg_to_watch = 0  THEN '1) same day as sign-up'
        WHEN days_reg_to_watch <= 7 THEN '2) 1-7 days later'
        ELSE                             '3) 8+ days later'
    END                                                                        AS first_engagement,
    COUNT(*)                                                                   AS students,
    ROUND(100.0 * SUM(first_date_purchased IS NOT NULL) / COUNT(*), 2)         AS conversion_rate_pct
FROM base
GROUP BY first_engagement
ORDER BY first_engagement;

-- 3. Conversion rate by registration month (acquisition cohort)
WITH first_watch AS (
    SELECT student_id, MIN(date_watched) AS first_date_watched FROM student_engagement GROUP BY student_id
),
first_purchase AS (
    SELECT student_id, MIN(date_purchased) AS first_date_purchased FROM student_purchases GROUP BY student_id
),
base AS (
    SELECT si.student_id, si.date_registered, fw.first_date_watched, fp.first_date_purchased
    FROM student_info si
    JOIN first_watch fw ON fw.student_id = si.student_id
    LEFT JOIN first_purchase fp ON fp.student_id = si.student_id
    WHERE fp.first_date_purchased IS NULL OR fw.first_date_watched <= fp.first_date_purchased
)
SELECT
    DATE_FORMAT(date_registered, '%Y-%m')                                      AS registration_month,
    COUNT(*)                                                                   AS engaged_students,
    ROUND(100.0 * SUM(first_date_purchased IS NOT NULL) / COUNT(*), 2)         AS conversion_rate_pct
FROM base
GROUP BY registration_month
ORDER BY registration_month;
