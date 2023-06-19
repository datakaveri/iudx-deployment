import os
import json
import psycopg2

# Load variables from config.json
with open('config.json') as config_file:
    config = json.load(config_file)

# Retrieve PostgreSQL credentials
postgres_host = config['postgres_host']
postgres_username = config['postgres_username']
postgres_password_file = config['postgres_password_file']

# Connect to PostgreSQL with the default user
try:
    with open(postgres_password_file, 'r') as file:
        postgres_password = file.read().strip()

    conn = psycopg2.connect(
        host=postgres_host,
        user=postgres_username,
        password=postgres_password
    )
    conn.autocommit = True
    cursor = conn.cursor()

    # Create additional users
    users = config['users']
    for user in users:
        username = user['username']
        password_file = user['password_file']

        # Retrieve user's password from file
        with open(password_file, 'r') as file:
            password = file.read().strip()

        # Create role
        cursor.execute(f"CREATE ROLE {username} WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;")
        print("Role ", username ,"created")
        cursor.execute(f"ALTER ROLE {username} WITH ENCRYPTED PASSWORD '{password}';")
        print("Role ", username ,"Altered")
        

        # Create database if applicable
        if 'database' in user.keys():
            database = user['database']
            cursor.execute(f"CREATE DATABASE {database} WITH ENCODING 'UTF8';")
            print("Database ", database ,"created")

        # Execute custom lines if provided
        if 'custom' in user.keys():
            custom_lines = user['custom']
            if isinstance(custom_lines, list):
                for custom_line in custom_lines:
                    cursor.execute(custom_line)
                    print("successfully executed ", custom_line)

    cursor.close()
    conn.close()
    print("User creation process completed successfully.")

except (Exception, psycopg2.Error) as error:
    print("Error connecting to PostgreSQL:", error)
