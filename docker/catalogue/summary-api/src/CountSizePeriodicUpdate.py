import psycopg2
from datetime import datetime , timedelta
from dateutil.relativedelta import relativedelta
from pytz import timezone
import json
import configparser
# This files help to periodic update Mlayer summary apis
with open("config.json") as file:
    config = json.load(file)
    user = config.get("username")
    password = config.get("password")
    host = config.get("host")
    port = config.get("port")
    database = config.get("database")
    databaseTableName = config.get("databasetablename")
    insertDatabaseTableName = config.get("insertdatabasetablename")
    excluded_ids = config.get('excluded_ids', [])
    excluded_ids_str = ""

    try:
        # Establish a connection to the database
        connection = psycopg2.connect(
            user = user,
            password = password,
            host = host,
            port = port,
            database = database
        )
        # Create a cursor object
        cursor = connection.cursor()

        # Get current time
        current = datetime.now()
        # Convert current time to UTC
        current_utc = current.astimezone(timezone('UTC'))
        # Get UTC time
        utc_time = current_utc.replace(tzinfo=None)
        # Get time one year back
        time_year_back = utc_time - relativedelta(years=1)
        # Get time six months back
        time_six_month_back = utc_time - relativedelta(months=6)
        # Get time one month back
        time_one_month_back = utc_time - relativedelta(months=1)
        # Get time one week back
        time_one_week_back = utc_time - timedelta(days=7)
        # Get time one day back
        time_one_day_back = utc_time - timedelta(days=1)

        # Execute a SELECT query
        if excluded_ids:
            excluded_ids_str = ",".join(f"'{str(id)}'" for id in excluded_ids)
            where_clause = f" userid NOT IN ({excluded_ids_str})"
            and_addition = " AND "
            where_addition = " where "
        else:
            where_clause = ""
            and_addition = ""
            where_addition = ""

        select_query = f"""
        SELECT
            (SELECT count(api) FROM {databaseTableName} {where_addition} {where_clause}) as total_count,
            (SELECT count(api) FROM {databaseTableName} WHERE time BETWEEN '{time_year_back}' AND '{utc_time}' {and_addition} {where_clause}) as year_count,
            (SELECT count(api) FROM {databaseTableName} WHERE time BETWEEN '{time_six_month_back}' AND '{utc_time}' {and_addition} {where_clause}) as six_month_count,
            (SELECT count(api) FROM {databaseTableName} WHERE time BETWEEN '{time_one_month_back}' AND '{utc_time}' {and_addition} {where_clause}) as one_month_count,
            (SELECT count(api) FROM {databaseTableName} WHERE time BETWEEN '{time_one_week_back}' AND '{utc_time}' {and_addition} {where_clause}) as one_week_count,
            (SELECT count(api) FROM {databaseTableName} WHERE time BETWEEN '{time_one_day_back}' AND '{utc_time}' {and_addition} {where_clause}) as one_day_count
        """
        print(select_query)
        select_query2 = f"""
        SELECT
            (SELECT COALESCE(sum(size), 0) FROM {databaseTableName} {where_addition} {where_clause}) as total_size,
            (SELECT COALESCE(sum(size), 0) FROM {databaseTableName} WHERE time BETWEEN '{time_year_back}' AND '{utc_time}' {and_addition} {where_clause}) as year_size,
            (SELECT COALESCE(sum(size), 0) FROM {databaseTableName} WHERE time BETWEEN '{time_six_month_back}' AND '{utc_time}' {and_addition} {where_clause}) as six_month_size,
            (SELECT COALESCE(sum(size), 0) FROM {databaseTableName} WHERE time BETWEEN '{time_one_month_back}' AND '{utc_time}' {and_addition} {where_clause}) as one_month_size,
            (SELECT COALESCE(sum(size), 0) FROM {databaseTableName} WHERE time BETWEEN '{time_one_week_back}' AND '{utc_time}' {and_addition} {where_clause}) as one_week_size,
            (SELECT COALESCE(sum(size), 0) FROM {databaseTableName} WHERE time BETWEEN '{time_one_day_back}' AND '{utc_time}' {and_addition} {where_clause}) as one_day_size
        """
        print(select_query2)
        cursor.execute(select_query)

        # Fetch all the rows
        records = cursor.fetchall()

        # Print the rows
        for row in records:
            print(row)

        cursor.execute(select_query2)

        # Fetch all the rows
        records2 = cursor.fetchall()

        # Print the rows
        for row in records2:
            print(row)

        totat_count = records[0][0]
        totat_size = records2[0][0]

        year_count = records[0][1]
        year_size = records2[0][1]

        six_month_count = records[0][2]
        six_month_size = records2[0][2]

        one_month_count = records[0][3]
        one_month_size = records2[0][3]

        one_week_count = records[0][4]
        one_week_size = records2[0][4]

        one_day_count = records[0][5]
        one_day_size = records2[0][5]

        insert_query = f"insert into {insertDatabaseTableName}(description,count,size) values('Total usage since the beginning',{totat_count},{totat_size}) on conflict(description) do update set count = {totat_count}, size = {totat_size}"

        cursor.execute(insert_query)
        connection.commit()

        insert_query = f"insert into {insertDatabaseTableName}(description,count,size) values('Total usage for the last 1 Year',{year_count},{year_size}) on conflict(description) do update set count = {year_count}, size = {year_size}"


        cursor.execute(insert_query)
        connection.commit()

        insert_query = f"insert into {insertDatabaseTableName}(description,count,size) values('Total usage for the last 6 months',{six_month_count},{six_month_size}) on conflict(description) do update set count = {six_month_count}, size = {six_month_size}"

        cursor.execute(insert_query)
        connection.commit()

        insert_query = f"insert into {insertDatabaseTableName}(description,count,size) values('Total usage for the last 1 month',{one_month_count},{one_month_size}) on conflict(description) do update set count = {one_month_count}, size = {one_month_size}"


        cursor.execute(insert_query)
        connection.commit()

        insert_query = f"insert into {insertDatabaseTableName}(description,count,size) values('Total usage for the last 1 week',{one_week_count},{one_week_size}) on conflict(description) do update set count = {one_week_count}, size = {one_week_size}"


        cursor.execute(insert_query)
        connection.commit()

        insert_query = f"INSERT INTO {insertDatabaseTableName}(description, count, size) VALUES('Total usage of Yesterday', COALESCE({one_day_count}, 0), COALESCE({one_day_size}, 0)) ON CONFLICT(description) DO UPDATE SET count = COALESCE({one_day_count}, 0), size = COALESCE({one_day_size}, 0)"


        cursor.execute(insert_query)
        connection.commit()
        print("\n completed")
    except (Exception, psycopg2.Error) as error:
        print("Error while connecting to PostgreSQL", error)

    finally:
        # Close the cursor and connection
        if (connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")

