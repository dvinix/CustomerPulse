# CustomerPulse

A customer churn prediction project using the Telco Customer Churn dataset.

## Project Structure

```
customer-pulse/
├── data/
│   ├── raw/            # Place WA_Fn-UseC_-Telco-Customer-Churn.csv here
│   └── processed/
├── sql/
│   ├── eda_queries.sql
│   └── setup.sql
├── notebooks/
│   ├── 01_sql_eda.ipynb
│   ├── 02_python_eda.ipynb
│   ├── 03_feature_engineering.ipynb
│   ├── 04_modelling.ipynb
│   └── 05_shap_explainability.ipynb
├── src/
│   ├── __init__.py
│   ├── data_loader.py
│   ├── features.py
│   ├── model.py
│   └── predict.py
├── app/
│   └── streamlit_app.py
├── models/
├── requirements.txt
├── Dockerfile
└── .gitignore
```

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Place the dataset in `data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv`

3. Run the Streamlit app:
```bash
streamlit run app/streamlit_app.py
```

## Docker

Build and run with Docker:
```bash
docker build -t customer-pulse .
docker run -p 8501:8501 customer-pulse
```
