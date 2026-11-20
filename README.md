# Free-to-Paid Conversion Analysis (SQL)

**Question:** How well does free content engagement turn into paid subscriptions on an e-learning platform, and where in the journey are we losing users?

**Stack:** MySQL 8 · CTEs · window functions · 40,979 registered users, 74,246 engagement events, 5,922 purchases (Dec 2021 – Oct 2022, PII removed)

---

## Executive summary

| KPI | Value | What it tells us |
|---|---|---|
| Free-to-paid conversion (engaged users) | **11.29 %** | 2,286 of 20,255 users who watched at least one lecture went on to buy |
| Avg. days registration → first lecture | **3.42** | Median is **0 days**: 85 % watch on sign-up day. The average is driven by a small group of late starters |
| Avg. days first lecture → first purchase | **26.25** | Median is **1 day**: 49 % buy on the day they first watch, 77 % within a week. A 9 % tail (90+ days) inflates the mean |

**The main point:** buying is mostly an *early* decision. The average says "users think about it for almost a month", but the distribution shows two different groups: users who decide within days, and a long tail of late buyers. Retention and upsell work should be split by these two groups instead of being aimed at the "average" user.

## Key findings

1. **Returning users convert better than same-day users.** Users whose first lecture was 1–7 days after sign-up converted at **17.6 %**, compared with **10.5 %** for users who watched on sign-up day. A return visit is a stronger intent signal than activity on day 0.
2. **Acquisition quality varies a lot by month.** Monthly cohorts convert between **7 % and 15 %**. The two biggest cohorts (Aug 2022: 2,632 users, Oct 2022: 2,545 users) converted at only **~7 %**, which points to lower-intent traffic (campaigns or promotions) rather than a product problem.
3. **The time-to-purchase distribution is very skewed:**

   | Time from first lecture to purchase | Share of buyers |
   |---|---|
   | Same day | 49.3 % |
   | 1–7 days | 27.2 % |
   | 8–30 days | 7.3 % |
   | 31–90 days | 6.7 % |
   | 90+ days | 9.4 % |

## Recommendations

| # | Recommendation | KPI to track |
|---|---|---|
| 1 | Put the strongest upgrade prompt into the **first session and the first 7 days**. That window covers about 3 out of 4 conversions. | % of buyers converting in week 1 |
| 2 | Add a **day-1 to day-7 "come back" trigger** (email/push with the next lesson). Returning users convert ~1.7x better. | D1–D7 return rate → conversion |
| 3 | Report conversion **by acquisition cohort and channel**, not only as one blended rate, so that high-volume, low-intent campaigns don't hide product changes. | Conversion by cohort/channel |
| 4 | Use **medians and distributions** for time-to-X KPIs on dashboards. Averages here overstate time to first engagement by ~3 days and time to purchase by ~25 days. | Median + P75/P90 |

## Method and definitions

- **Population:** users with at least one lecture watched. 523 users who bought *before* ever watching are excluded, because they did not convert from free engagement.
- **Conversion:** first purchase on or after the first lecture date.
- **Time-to-X:** day differences between the first registration, first lecture and first purchase dates (`DATEDIFF`).
- **Limitations:** the data has no channel, plan price or device fields, so the cohort differences can only be described, not explained. The analysis is observational: it shows correlation, not cause and effect.

## Files

| File | Content |
|---|---|
| [`free-to-paid-conversion-rate.sql`](free-to-paid-conversion-rate.sql) | Headline KPIs (conversion rate, average time-to-engage, average time-to-purchase) |
| [`conversion-deep-dive.sql`](conversion-deep-dive.sql) | Time-to-convert distribution, conversion by return behaviour, conversion by registration cohort |
| [`interpretation.md`](interpretation.md) | Detailed interpretation of the results |
| [`db_course_conversions.sql`](db_course_conversions.sql) | MySQL dump of the anonymised dataset |

## How to run

```bash
mysql -u <user> -p < db_course_conversions.sql        # creates and loads db_course_conversions
mysql -u <user> -p < free-to-paid-conversion-rate.sql
mysql -u <user> -p < conversion-deep-dive.sql
```

*Dataset: 365 Data Science, used as a guided case study. The deep-dive analysis, findings and recommendations are my own.*
