# Interpretation of Results

> **Correction (Nov 2026):** an earlier version of this file had the three KPI values in the wrong places (conversion was shown as 3.42 %). The values below come from re-running `free-to-paid-conversion-rate.sql` on the dump in this repository.

| KPI | Mean | Median |
|---|---|---|
| Free-to-paid conversion rate | 11.29 % | – |
| Days from registration to first lecture | 3.42 | 0 |
| Days from first lecture to first purchase | 26.25 | 1 |

## 1. Conversion rate: 11.29 %

About 1 in 9 users who watched at least one lecture became a paying customer. For a freemium e-learning product this is a healthy result. Freemium benchmarks are usually quoted in the low single digits for *all* sign-ups, and our base is already filtered to engaged users. So the question is less "is the product compelling?" and more "which users convert, and how do we get more of them?"

## 2. Registration → first lecture: mean 3.42 days, median 0

Onboarding works for most users: 85 % watch a lecture on the day they sign up. The mean is higher because of a small group who come back weeks later. This group is a re-activation target, not a sign of a general onboarding problem.

Users who came back on day 1–7 for their first lecture converted at 17.6 %, compared with 10.5 % for users who watched on sign-up day. Coming back on its own is a strong intent signal, and it is a good leading indicator to track.

## 3. First lecture → purchase: mean 26.25 days, median 1

Half of all buyers (49 %) pay on the day of their first lecture, and 77 % within a week. A 9 % tail of buyers who need 90+ days pulls the mean up to almost a month. In practice:

- The **paywall and upgrade messaging in the first session** matter most.
- **Time-limited offers** work best inside the first week. After that, users need a separate nurture flow, for example new content or certificate-driven messaging.
- Dashboards should show the **median and P90**, not only the mean. Otherwise stakeholders plan for a 26-day decision cycle that most users don't have.

## 4. Cohorts

Monthly registration cohorts convert between 6.95 % (Oct 2022) and 15.13 % (Jan 2022). The two biggest months (Aug and Oct 2022) have the lowest conversion. This suggests that volume came from lower-intent traffic. The next step would be to join channel and campaign data to confirm it.

## Limitations

- The analysis is observational: these are correlations, not causal effects.
- Fields for channel, price, plan type and device are not available.
- Users who purchased before watching (523) are excluded by definition.
