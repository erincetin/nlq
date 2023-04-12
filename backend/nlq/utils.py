from sqlalchemy import create_engine
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

from backend.backend import settings


# from backend import settings
# from django.conf import settings

#
def connect_sql_db(db_type, username, password, server, db):
    connection_string = f"://{username}:{password}@{server}/{db}"

    if db_type == 'mysql':
        connection_string = "mysql+pymysql" + connection_string

    elif db_type == 'postgresql':
        connection_string = "postgresql+psycopg2" + connection_string

    elif db_type == 'mssql':
        connection_string = "mssql+pymssql" + connection_string
    elif db_type == 'oracle':
        connection_string = "oracle+cx_oracle" + connection_string

    engine = create_engine(connection_string)

    return engine

# this function is returning the string to frontend for storage, and it will be required for the get_sql_function
def database_info(db_type, username, password, hostname, database):
    # this will most likely will be a put method but for now it will stay as post

    if db_type == 'mysql':
        db_info = mysql_mssql_info(username, password, hostname, database, 0)
    elif db_type == 'postgresql':
        db_info = postgresql_info(username, password, hostname, database)
    elif db_type == 'mssql':
        db_info = mysql_mssql_info(username, password, hostname, database, 1)
    elif db_type == 'oracle':
        db_info = oracle_info(username, password, hostname, database)

    return db_info


def get_sql(query):
    input_text = query

    features = settings.tokenizer([input_text], return_tensors='pt')

    output = settings.model.generate(input_ids=features['input_ids'],
                                     attention_mask=features['attention_mask'])

    print(query)
    print(settings.tokenizer.decode(output[0]))
    return settings.tokenizer.decode(output[0])


def make_info_string(tables):
    # this tables[0] can be not working as intended
    db_info_string = " | " + tables[0]["table_schema"] + " | "
    for table in tables:
        db_info_string += table["table_name"] + " : "
        for column in table["columns"]:
            db_info_string += column["column_name"] + ", "
        db_info_string = db_info_string[:-2]
        db_info_string += " | "
    db_info_string = db_info_string[:-3]
    print(db_info_string)
    return db_info_string


def postgresql_info(username, password, hostname, database):
    engine = connect_sql_db('postgresql', username, password, hostname, database)

    tables = postgres_get_table_info(engine)
    if len(tables) == 0:
        print("No table")
        return None

    tables_dict = []
    for table in tables:
        n_table = {"table_schema": table[0], 'table_name': table[1],
                   "columns": postgres_get_column_info(engine, table[0], table[1])}
        tables_dict.append(n_table)

    db_info_string = make_info_string(tables_dict)
    return db_info_string


def mysql_mssql_info(username, password, hostname, database, d_type):
    if d_type == 0:
        engine = connect_sql_db('mysql', username, password, hostname, database)
    elif d_type == 1:
        engine = connect_sql_db('mssql', username, password, hostname, database)

    tables = mysql_mssql_get_table_info(engine)
    if len(tables) == 0:
        print("No table")
        return None

    tables_dict = []
    for table in tables:
        n_table = {"table_schema": table[0], 'table_name': table[1],
                   "columns": mysql_mssql_get_column_info(engine, table[0], table[1])}
        tables_dict.append(n_table)

    db_info_string = make_info_string(tables_dict)
    return db_info_string


def oracle_info(username, password, hostname, database):
    engine = connect_sql_db('oracle', username, password, hostname, database)
    tables = oracle_get_table_info(engine)

    if len(tables) == 0:
        print("No table")
        return None

    tables_dict = []
    for table in tables:
        n_table = {"table_schema": table[0], 'table_name': table[1],
                   "columns": oracle_get_column_info(engine, table[1])}
        tables_dict.append(n_table)

    db_info_string = make_info_string(tables_dict)
    return db_info_string


def oracle_get_table_info(engine):
    cursor = engine.raw_connection().cursor()

    query = "SELECT owner, table_name " \
            "FROM all_tables " \
            "WHERE owner like 'USER%' " \
            "Order by table_schema, table_name "
    cursor.execute(query)
    tables = cursor.fetchall()
    cursor.close()
    return tables


def oracle_get_column_info(engine, table):
    cursor = engine.raw_connection().cursor()

    query = "SELECT column_name " \
            "FROM  ALL_TAB_COLUMNS " \
            "WHERE table_name = UPPER(%s)" % table
    cursor.execute(query)
    columns = cursor.fetchall()
    cursor.close()
    return columns


def postgres_get_table_info(engine):
    # take the connection to database

    cursor = engine.raw_connection().cursor()

    query = "SELECT table_schema, table_name " \
            "FROM information_schema.tables " \
            "WHERE table_schema = 'public' " \
            "AND table_type = 'BASE TABLE' " \
            "Order by table_schema, table_name "
    cursor.execute(query)
    tables = cursor.fetchall()
    cursor.close()
    return tables


def postgres_get_column_info(engine, schema, table):
    cursor = engine.raw_connection().cursor()

    query = "SELECT column_name " \
            "FROM information_schema.columns " \
            "WHERE table_schema = %s And table_name = %s " \
            "ORDER BY ordinal_position" % (schema, table)
    cursor.execute(query)
    columns = cursor.fetchall()
    cursor.close()
    return columns


def mysql_mssql_get_table_info(engine):
    # take the connection to database

    cursor = engine.raw_connection().cursor()

    query = "SELECT table_schema, table_name " \
            "FROM information_schema.tables " \
            "WHERE table_type = 'BASE TABLE' and table_schema != 'performance_schema' " \
            "Order by table_schema, table_name "
    cursor.execute(query)
    tables = cursor.fetchall()
    cursor.close()
    return tables


def mysql_mssql_get_column_info(engine, schema, table):
    cursor = engine.raw_connection().cursor()

    query = "SELECT column_name " \
            "FROM information_schema.columns " \
            "WHERE table_schema = %s And table_name = %s " \
            "ORDER BY ordinal_position" % (schema, table)
    cursor.execute(query)
    columns = cursor.fetchall()
    cursor.close()
    return columns
