"""Data loading utilities."""
import pandas as pd
from sqlalchemy import create_engine
import os


def load_and_clean_data(csv_path='data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv'):
    """
    Load and clean the Telco Customer Churn dataset.
    
    Args:
        csv_path: Path to the CSV file
        
    Returns:
        Cleaned pandas DataFrame
    """
    print(f"Loading data from {csv_path}...")
    df = pd.read_csv(csv_path)
    
    # Clean TotalCharges: convert blank strings to 0, cast to float
    print("Cleaning TotalCharges column...")
    df['TotalCharges'] = df['TotalCharges'].replace(' ', '0')
    df['TotalCharges'] = df['TotalCharges'].astype(float)
    
    # Convert Churn from Yes/No to 1/0
    print("Converting Churn column to binary...")
    df['Churn'] = df['Churn'].map({'Yes': 1, 'No': 0})
    
    return df


def load_to_database(df, db_path='data/processed/telco.db', table_name='customers'):
    """
    Load DataFrame into SQLite database.
    
    Args:
        df: pandas DataFrame to load
        db_path: Path to SQLite database file
        table_name: Name of the table to create
    """
    # Create directory if it doesn't exist
    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    
    # Create SQLAlchemy engine
    engine = create_engine(f'sqlite:///{db_path}')
    
    print(f"Loading data to database: {db_path}")
    print(f"Table name: {table_name}")
    
    # Load to database
    df.to_sql(table_name, engine, if_exists='replace', index=False)
    
    # Print summary
    print(f"\n✓ Successfully loaded {len(df)} rows to database")
    print(f"\nColumns ({len(df.columns)}):")
    for col in df.columns:
        print(f"  - {col}")
    
    return engine


def main():
    """Main execution function."""
    # Load and clean data
    df = load_and_clean_data()
    
    # Load to database
    engine = load_to_database(df)
    
    # Verify the load
    print("\n--- Verification ---")
    with engine.connect() as conn:
        result = pd.read_sql("SELECT COUNT(*) as count FROM customers", conn)
        print(f"Row count in database: {result['count'][0]}")
        
        churn_dist = pd.read_sql(
            "SELECT Churn, COUNT(*) as count FROM customers GROUP BY Churn", 
            conn
        )
        print("\nChurn distribution:")
        print(churn_dist)


if __name__ == "__main__":
    main()
