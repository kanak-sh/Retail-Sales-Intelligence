from sqlalchemy import create_engine, text
from urllib.parse import quote_plus

username = "root"
password = quote_plus("naman@123")
host = "localhost"
database = "retail_sales_intelligence"

engine = create_engine(
    f"mysql+pymysql://{username}:{password}@{host}/{database}"
)

with engine.begin() as conn:
    conn.execute(text("""
        INSERT INTO dim_customers
        (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
        VALUES
        ('TEST123', 'UNIQUE123', 12345, 'test_city', 'TS')
    """))

print("Inserted successfully!")