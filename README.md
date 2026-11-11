# A/B Test & Experiment Analysis | Landing Page Conversion Optimization

## Project Overview

This project evaluates whether a redesigned landing page improves user conversion rates compared with an existing landing page.

Using a public A/B testing dataset, I performed data cleaning, experiment validation, hypothesis testing, statistical power analysis, and PostgreSQL analysis to develop a data-driven business recommendation.

**Final recommendation:** Do not roll out the new landing page based on the available evidence.

## Business Problem

A business wants to determine whether replacing its existing landing page with a redesigned version will increase conversions.

The analysis addresses three questions:

1. Does the new landing page improve conversion rates?
2. Is the observed difference statistically significant?
3. Should the business implement the redesigned page?

## Tools and Technologies

- **Python:** pandas, NumPy, SciPy, statsmodels
- **PostgreSQL:** SQL queries, aggregations, CTEs, and window functions
- **Jupyter Notebook:** Exploratory and statistical analysis
- **VS Code:** Project development
- **GitHub:** Version control and portfolio presentation

## Dataset

The project uses a public A/B testing dataset containing user-level experiment observations.

The dataset includes:

| Column | Description |
|---|---|
| `user_id` | Unique user identifier |
| `timestamp` | Experiment observation timestamp |
| `group` | Control or treatment assignment |
| `landing_page` | Old or new landing page |
| `converted` | Binary conversion outcome (0 or 1) |

- Original dataset: **294,478 rows**
- Cleaned dataset: **290,584 rows**
- Control group: **145,274 users**
- Treatment group: **145,310 users**

Cleaning included removing inconsistent group/page observations and duplicate user records. These exclusions may affect causal interpretation and are treated as an analysis limitation.

## Analysis Workflow

### 1. Data Exploration and Cleaning

- Inspected dataset structure and missing values.
- Identified duplicate user IDs.
- Checked consistency between experiment assignments and landing pages.
- Created a cleaned dataset for analysis.

### 2. Experiment Validation

Performed a Sample Ratio Mismatch (SRM) check to assess the balance of original experiment assignments.

- Chi-square statistic: **0.0186**
- P-value: **0.8915**

The test did not identify statistically significant evidence of a sample ratio mismatch.

### 3. Conversion Rate Analysis

Calculated conversion rates for control and treatment groups.

### 4. Hypothesis Testing

Performed a two-sided two-proportion z-test and calculated a 95% confidence interval for the treatment-minus-control conversion-rate difference.

### 5. Statistical Power Analysis

- Assumed baseline conversion rate: 12%
- Target conversion rate: 13%
- Significance level: 5%
- Statistical power: 80%
- Estimated required sample size: **17,164 users per group**
- Approximate minimum detectable effect with actual sample sizes: **0.3378 percentage points**

These calculations depend on the stated assumptions.

### 6. PostgreSQL Analysis

Imported the cleaned dataset into PostgreSQL and developed SQL queries for:

- Group-level user counts
- Conversion rates
- Absolute and relative lift
- Daily conversion trends
- Cumulative conversion rates using window functions

## Key Results

| Metric | Result |
|---|---:|
| Control conversion rate | 12.0386% |
| Treatment conversion rate | 11.8808% |
| Absolute lift | -0.1578 percentage points |
| Relative lift | -1.311% |
| Two-sided p-value | 0.1899 |
| 95% confidence interval | [-0.3938, +0.0781] percentage points |

The treatment group had a slightly lower observed conversion rate than the control group.

However, the difference was **not statistically significant** at the 5% significance level.

The confidence interval includes zero, meaning the experiment does not provide sufficient evidence of a conversion-rate improvement or decline.

## Business Recommendation

**Retain the existing landing page for now.**

The redesigned landing page did not demonstrate a statistically significant improvement in conversion rates.

Before considering another rollout, the business should review experiment quality, implementation costs, and the potential value of additional testing.

A non-significant result does not prove that the two landing pages perform equally.

## Limitations

- The analysis uses a public sample dataset rather than live company experiment data.
- Removing mismatched group/page observations could introduce selection bias.
- The experiment's original business costs and decision thresholds are unavailable.
- Daily and cumulative conversion trends are exploratory and do not establish additional statistical significance.

## Project Structure

```text
AB_Test_Experiment_Analysis/
├── AB_Test_Analysis.ipynb
├── ab_data.csv
├── ab_data_cleaned.csv
├── sql/
│   └── ab_test_queries.sql
├── README.md
├── requirements.txt
└── .gitignore
```

## How to Run

1. Clone or download the repository.
2. Create a Python virtual environment.
3. Install the dependencies listed in `requirements.txt`.
4. Open `AB_Test_Analysis.ipynb` in Jupyter or VS Code.
5. Run the notebook cells in order.
6. For SQL analysis, create a PostgreSQL database and an `ab_test` table with the appropriate column types.
7. Import `ab_data_cleaned.csv` into the table.
8. Run the queries in `sql/ab_test_queries.sql`.

## Skills Demonstrated

Python Data Analysis | A/B Testing | Experiment Validation | Hypothesis Testing | Confidence Intervals | Statistical Power | PostgreSQL | SQL CTEs | Window Functions | Business Decision-Making

---

**Project purpose:** Demonstrate an end-to-end experimentation analysis workflow, from raw data to a statistically grounded business recommendation.
