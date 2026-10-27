# Hospital Healthcare Analytics

An end-to-end healthcare analytics portfolio project using **MySQL, Python (Pandas, NumPy, Matplotlib, Seaborn), and Power BI**. The project explores encounter activity, patient patterns, claim costs, payer coverage, procedure costs, and data quality.

## Project goals

- Inspect healthcare tables and assess data quality.
- Use SQL to answer operational and cost-related business questions.
- Load database tables into Python for cleaning, exploration, and visualization.
- Present key metrics and patterns in an interactive Power BI dashboard.

## Tools

- **MySQL:** data exploration, quality checks, joins, aggregations, CTEs, window functions, and business queries.
- **Python:** Pandas, NumPy, Matplotlib, Seaborn, SQLAlchemy, PyMySQL, and python-dotenv.
- **Power BI:** KPI cards, year and encounter-type slicers, and visuals for encounter trends, encounter types, claim costs, and payer coverage.

## Repository structure

```text
Hospital_Healthcare_Analytics/
├── data/                 # Dataset CSV files and data-source citation
├── images/
│   └── dashboard.png     # Power BI dashboard screenshot
├── powerbi/
│   └── Hospital_Dashboard.pbix
├── python/
│   └── hospital_eda.ipynb
├── sql/
│   ├── Hospital_Project.sql
│   ├── hospital_analytics_questions.sql
│   └── create_hospital_db.sql
├── .env.example
├── .gitignore
├── requirements.txt
└── README.md
```

## Dataset

The repository includes CSV exports for patients, encounters, payers, procedures, organizations, and a data dictionary. Review `data/citation.txt` for the dataset citation. The source data is synthetic healthcare data; do not interpret the records as real patient information.

## SQL analysis

The SQL scripts cover:
- Table exploration and row counts
- Missing-value, duplicate, invalid-cost, and unmatched-key checks
- Patient and encounter joins, including a four-table join
- Yearly encounter counts and encounter-class percentages
- Encounter duration and payer coverage
- Frequent and high-cost procedures
- Average claim cost by payer
- Patient revisit/readmission-style analysis
- Cost patterns by age group, encounter class, and reason

`sql/Hospital_Project.sql` is the main analysis script. Some checks and comments describe expected results; run the queries against your local database to verify them before relying on those values.

## Python EDA

The notebook in `python/hospital_eda.ipynb` connects to a local MySQL database and performs data inspection, cleaning, and exploratory analysis. The notebook expects a database named `hospital_db` with the required tables.

### Configure the database connection

1. Install MySQL and create/import the `hospital_db` database using your preferred method.
2. Create a local `.env` file in the repository root (do not commit it).
3. Add your own connection details:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=your_mysql_username
DB_PASSWORD=your_mysql_password
DB_NAME=hospital_db
```

4. Run the notebook from the repository root so the `.env` file can be found, or adjust the notebook's environment-file path if you run it from another working directory.

Do not put real passwords or other secrets in this repository.

## Install Python dependencies

```bash
python -m venv .venv
```

Activate the virtual environment, then run:

```bash
pip install -r requirements.txt
```

Launch Jupyter Notebook or JupyterLab and open `python/hospital_eda.ipynb`.

## Power BI dashboard

Open `powerbi/Hospital_Dashboard.pbix` in Power BI Desktop. The dashboard includes KPI cards, year and encounter-type slicers, yearly encounter trends, encounter-type comparison, average claim cost, average payer coverage, zero-coverage encounters, and claim-cost breakdowns.

![Hospital Healthcare Analytics Dashboard](images/dashboard.png)

The source data ends in February 2022, so 2022 represents a partial year. Interpret year-to-year comparisons with that limitation in mind. Dashboard values should be validated against the SQL results after refreshing the model.

## Important interpretation notes

- A revisit within 30 days is not automatically a clinical hospital readmission. The SQL includes both a broad any-encounter measure and an inpatient-only variant.
- Encounter duration across all encounter classes should not be described as hospital length of stay for every class.
- Joining encounters to procedures can create multiple rows per encounter. Do not sum encounter-level claim costs after that join without first preventing double-counting.
- Confirm all reported metrics against the database before presenting them as final results.

## Future improvements

- Add screenshots of selected SQL results and Python charts.
- Validate and document final KPI values after a complete refresh.
- Add a short business recommendations section based on verified findings.

## Source citation

See [`data/citation.txt`](data/citation.txt) for the dataset citation.
