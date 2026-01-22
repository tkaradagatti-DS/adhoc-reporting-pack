# adhoc-reporting-pack
A portfolio project showing how to handle recurring stakeholder requests quickly using:
- a reusable **SQL query library**
- a one‑click **Excel reporting pack generator**
- built-in **data quality checks** (process improvement)

> ✅ Data is **synthetic** (safe to publish).  
> ✅ Produces an Excel pack with multiple tabs + a Data Quality summary tab.

---
## Business Question

How can we respond to common internal requests like:
- “What’s monthly revenue?”
- “Top products this quarter?”
- “What’s our return rate?”
- “Any late deliveries?”
…using a consistent, repeatable reporting pack that reduces manual effort?

---

## What I delivered

- A SQL query library (`sql/adhoc_queries/`) that answers common business questions.
- A Python script that generates `outputs/adhoc_reporting_pack.xlsx`.
- A “Data_Quality” tab that flags:
  - duplicates
  - missing shipment dates
  - invalid quantities / inconsistent records
- Standardised structure so the same pack can be regenerated weekly/monthly.

---

## Key checks / assumptions

- Quantities must be positive; invalid rows are flagged for review.
- Return rate is calculated as: returned orders / shipped orders (by month).
- Late deliveries are identified using ship date vs order date lead-time thresholds.
- Consistent region and segment fields are assumed for grouping and comparisons.

---

## Insights (3 bullets)

> Replace with your real findings after you refresh/re-run.

- A standard pack format reduces repeat work and helps stakeholders self-serve recurring questions.
- Returns and delivery delays are best tracked as trends + “top drivers” tables (products/regions).
- Including a data quality tab prevents “silent errors” from spreading into KPI reports.

---

## Tech stack

- SQL (schemas + ad-hoc query library)
- Python (pandas + openpyxl) for Excel pack generation
- Excel (stakeholder-friendly output)

---

## Data (synthetic)

Located in `data/raw/`:
- `customers.csv`
- `products.csv`
- `orders.csv`
- `returns.csv`

---

## Repo structure

```text
03-adhoc-reporting-pack/
  data/
    raw/
  python/
    generate_excel_report.py
    requirements.txt
  sql/
    00_schema.sql
    10_views.sql
    20_quality_checks.sql
    adhoc_queries/
  outputs/
    adhoc_reporting_pack.xlsx
