from sqlalchemy import create_engine


def connect_sql_db(db_type, username, password, server, db):
    connection_string = f"://{username}:{password}@{server}/{db}"

    if db_type == 'mysql':
        connection_string = "mysql+mysqldb" + connection_string

    elif db_type == 'postgresql':
        connection_string = "postgresql+psycopg2" + connection_string

    elif db_type == 'mssql':
        connection_string = "mssql+pyodbc" + connection_string
    elif db_type == 'oracle':
        connection_string = "oracle+cx_oracle" + connection_string

    engine = create_engine(connection_string)

    return engine

