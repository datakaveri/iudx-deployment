# CountSizePeriodicUpdate.py

This Python script is used to periodically update a summary of API usage in a PostgreSQL database. It calculates the total usage and usage over different periods (1 day, 1 week, 1 month, 6 months, and 1 year) and updates these values in a specified table in the database.

## Dependencies

The script uses the following Python libraries:

- `psycopg2`: A PostgreSQL database adapter for Python.
- `datetime` and `timedelta`: Standard Python libraries for working with dates and times.
- `dateutil.relativedelta`: A library for working with relative dates and times.
- `pytz`: A Python library for timezone conversions.
- `json`: A standard Python library for working with JSON data.
- `configparser`: A standard Python library for parsing configuration files.

## Configuration

The script reads its configuration from a JSON file named `config.json`. This file should be located in the same directory as the script and should contain the following keys:

- `username`: The username for the PostgreSQL database.
- `password`: The password for the PostgreSQL database.
- `host`: The host of the PostgreSQL database.
- `port`: The port of the PostgreSQL database.
- `database`: The name of the PostgreSQL database.
- `databasetablename`: The name of the table in the database from which the script reads the API usage data.
- `insertdatabasetablename`: The name of the table in the database where the script writes the summary data.
- `excluded_ids` (optional): A list of resource IDs to exclude from the calculations.

## Usage

```sh
docker build -t ghcr.io/datakaveri/cat-summary-script:1.0.0  .
```

The script will connect to the PostgreSQL database, calculate the API usage statistics, and update the summary table. If there are any errors during this process, they will be printed to the console.