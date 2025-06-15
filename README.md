# Calculating Free-to-Paid Conversion Rate with SQL

This project aims to estimate the free-to-paid conversion rate of students on the 365 platform who engage with lecture content. The dataset has been stripped of personally identifiable information.

## 📌 Project Objectives

- Calculate the free-to-paid conversion rate of students who have watched at least one lecture.
- Compute average durations between:
  - Registration and first-time engagement
  - First-time engagement and first-time subscription purchase
- Interpret the implications of the results.

## 📁 Folder Structure

```text
data/
├── db_course_conversions.sql         # SQL dump of the database

querie/
├── free-to-paid-conversion-rate.sql  # Query to calculate final metrics

analysis/
├── interpretation                # Written interpretation of calculated metrics

README.md                             # This file
