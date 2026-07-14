import pandas as pd
import pymysql
from pathlib import Path

# ==========================
# Database Configuration
# ==========================
connection = pymysql.connect(
    host="localhost",
    user="root",
    password="naman@123",
    database="retail_sales_intelligence",
    charset="utf8mb4",
    autocommit=False
)

cursor = connection.cursor()

# ==========================
# Paths
# ==========================
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_PATH = BASE_DIR / "data" / "processed"

# ==========================
# CSV -> Table Mapping
# ==========================
tables = {
    "customers_cleaned.csv": "dim_customers",
    "products_cleaned.csv": "dim_products",
    "sellers_cleaned.csv": "dim_sellers",
    "category_translation_cleaned.csv": "dim_category_translation",
    "orders_cleaned.csv": "fact_orders",
    "order_items_cleaned.csv": "fact_order_items",
    "payments_cleaned.csv": "fact_payments",
    "reviews_cleaned.csv": "fact_reviews"
}

# ==========================
# Load Data
# ==========================
loaded_tables = {
    "dim_customers"
}

for csv_file, table in tables.items():

    if table in loaded_tables:
        print(f"Skipping {table}...")
        continue

    print(f"\nLoading {table}...")

    file_path = DATA_PATH / csv_file

    df = pd.read_csv(file_path)

    df.rename(columns={
        "product_name_lenght": "product_name_length",
        "product_description_lenght": "product_description_length"
    }, inplace=True)

    df = df.astype(object)
    df = df.where(pd.notnull(df), None)

    columns = list(df.columns)

    placeholders = ",".join(["%s"] * len(columns))

    column_names = ",".join(columns)

    sql = f"""
        INSERT INTO {table}
        ({column_names})
        VALUES ({placeholders})
    """

    data = [tuple(x) for x in df.itertuples(index=False, name=None)]

    try:
        cursor.executemany(sql, data)
        connection.commit()
        print(f"✓ {len(df):,} rows inserted into {table}")

    except Exception as e:
        connection.rollback()
        print(f"\n❌ Error loading {table}")
        print(e)
        break

cursor.close()
connection.close()

print("\n========== DONE ==========")