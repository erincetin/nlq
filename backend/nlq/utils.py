from sqlalchemy import create_engine
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
#from django.conf import settings
from backend import settings
#
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


def get_sql(query):
    input_text = query


    features = settings.tokenizer([input_text], return_tensors='pt')

    output = settings.model.generate(input_ids=features['input_ids'],
                            attention_mask=features['attention_mask'])

    print(query)
    print(settings.tokenizer.decode(output[0]))
    return settings.tokenizer.decode(output[0])