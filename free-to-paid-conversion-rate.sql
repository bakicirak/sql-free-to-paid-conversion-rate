USE db_course_conversions;

-- CTE: Get the first watched date per student
WITH FirstWatched AS (
    SELECT 
        student_id,
        MIN(date_watched) AS first_date_watched
    FROM student_engagement
    GROUP BY student_id
),

-- CTE: Get the first purchase date per student
FirstPurchased AS (
    SELECT 
        student_id,
        MIN(date_purchased) AS first_date_purchased
    FROM student_purchases
    GROUP BY student_id
),

-- CTE: Combine student registration, first engagement, and first purchase data
ResultSet AS (
    SELECT 
        si.student_id,
        si.date_registered,
        fw.first_date_watched,
        fp.first_date_purchased,
        
        -- Days from registration to first watched
        DATEDIFF(fw.first_date_watched, si.date_registered) AS date_diff_reg_watch,
        
        -- Days from first watched to first purchase (NULL if never purchased)
        CASE 
            WHEN fp.first_date_purchased IS NOT NULL 
            THEN DATEDIFF(fp.first_date_purchased, fw.first_date_watched) 
            ELSE NULL 
        END AS date_diff_watch_purch
    FROM student_info si
    INNER JOIN FirstWatched fw ON si.student_id = fw.student_id
    LEFT JOIN FirstPurchased fp ON si.student_id = fp.student_id
    WHERE fw.first_date_watched IS NOT NULL
      AND (fp.first_date_purchased IS NULL OR fw.first_date_watched <= fp.first_date_purchased)
)

-- Final select: Calculate all three KPIs in one row
SELECT
    -- Conversion rate: percentage of students who purchased after watching
    round((COUNT(CASE WHEN first_date_purchased IS NOT NULL THEN 1 END) * 100.0) / COUNT(*),2) AS conversion_rate,

    -- Average number of days from registration to first engagement
    round(AVG(date_diff_reg_watch),2) AS avg_reg_to_engage_days,

    -- Average number of days from engagement to purchase
    round(AVG(date_diff_watch_purch),2) AS avg_engage_to_purchase_days
FROM ResultSet;
