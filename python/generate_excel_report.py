"""Generate an Excel ad-hoc reporting pack (Project 3)

Outputs:
- outputs/adhoc_reporting_pack.xlsx

Run:
  pip install -r requirements.txt
  python generate_excel_report.py
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(parents=True, exist_ok=True)

def main() -> None:
    customers = pd.read_csv(RAW / "customers.csv")
    products = pd.read_csv(RAW / "products.csv")
    orders = pd.read_csv(RAW / "orders.csv")
    returns = pd.read_csv(RAW / "returns.csv")

    # Parse dates
    orders["order_date"] = pd.to_datetime(orders["order_date"], errors="coerce")
    orders["ship_date"] = pd.to_datetime(orders["ship_date"], errors="coerce")

    # Join for analysis
    df = orders.merge(customers, on="customer_id", how="left").merge(products, on="product_id", how="left")
    df["revenue_gbp"] = df["quantity"] * df["unit_price_gbp"]

    # -----------------
    # Data quality tab
    # -----------------
    dq = []
    dup_customers = customers.duplicated(subset=["customer_id"]).sum()
    dq.append(("Duplicate customers", int(dup_customers)))

    neg_qty = (orders["quantity"] <= 0).sum()
    dq.append(("Negative/zero quantity orders", int(neg_qty)))

    missing_ship = ((orders["status"] == "Shipped") & (orders["ship_date"].isna())).sum()
    dq.append(("Missing ship_date for shipped orders", int(missing_ship)))

    dq_df = pd.DataFrame(dq, columns=["check", "count"])

    # -----------------
    # KPI summaries
    # -----------------
    shipped = df[df["status"] == "Shipped"].copy()
    shipped["month"] = shipped["order_date"].dt.to_period("M").astype(str)

    monthly_region = shipped.groupby(["month","region"], as_index=False)["revenue_gbp"].sum().sort_values(["month","revenue_gbp"], ascending=[True,False])
    top_products = shipped.groupby("product_name", as_index=False)["revenue_gbp"].sum().sort_values("revenue_gbp", ascending=False).head(15)

    # Return rate
    shipped_orders = shipped[["order_id","month"]].drop_duplicates()
    returned_orders = returns[["order_id"]].drop_duplicates()
    shipped_orders["is_returned"] = shipped_orders["order_id"].isin(returned_orders["order_id"]).astype(int)
    return_rate = shipped_orders.groupby("month", as_index=False)["is_returned"].mean().rename(columns={"is_returned":"return_rate"})

    # Late deliveries
    shipped["lead_time_days"] = (shipped["ship_date"] - shipped["order_date"]).dt.days
    late = shipped[shipped["lead_time_days"] > 5][["order_id","order_date","ship_date","lead_time_days","region","segment"]].sort_values("lead_time_days", ascending=False).head(50)

    # -----------------
    # Write Excel pack
    # -----------------
    out_path = OUTPUTS / "adhoc_reporting_pack.xlsx"
    with pd.ExcelWriter(out_path, engine="openpyxl") as writer:
        dq_df.to_excel(writer, sheet_name="Data_Quality", index=False)
        monthly_region.to_excel(writer, sheet_name="Monthly_Revenue", index=False)
        top_products.to_excel(writer, sheet_name="Top_Products", index=False)
        return_rate.to_excel(writer, sheet_name="Return_Rate", index=False)
        late.to_excel(writer, sheet_name="Late_Deliveries", index=False)

    print("Done:", out_path)

if __name__ == "__main__":
    main()
