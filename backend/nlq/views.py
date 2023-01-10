from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
import json
import requests
import psycopg2
import psycopg2.extras
from .utils import connect_sql_db, get_sql
from django.views.decorators.csrf import csrf_exempt


# Create your views here.


def hello(request):
    return HttpResponse("Hello")


@csrf_exempt
def get_sql_query(request):
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    input_sentence = data.get("input")
    # port = data.get("port")
    port = 5430
    # hostname = data.get("server")
    hostname = data.get("server")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")

    database_info = " | concert_singer | stadium : stadium_id, location, name, capacity, highest, lowest, average | " \
                    "singer : singer_id, name, country, song_name, song_release_year, age, is_male | concert : " \
                    "concert_id, concert_name, theme, stadium_id, year | singer_in_concert : concert_id, singer_id"

    company_format = " | company | departments : department_id, department_name | dept_emp : employee_id, department_id, from_date, to_date | dept_manager : department_id, employee_id, from_date, to_date | employees : employee_id, birth_date, first_name, last_name, gender, hire_date | salaries : employee_id, salary, from_date, to_date | titles : employee_id, title, from_date, to_date"
    if input_sentence is None:
        return JsonResponse(
            {"status": "error", "message": "Input is required"}, status=404)

    query = get_sql(input_sentence + database_info)
    query = query[:-4]
    query = query[query.find("select"):]

    """r = requests.post("https://015346d8-f7ef-47f9.gradio.live/run/predict",
                      json={  # url will be changed according to colab link
                          "data": [input_sentence, database_info]}).json()
                                   # these can be changed back to hello world if they give errors

    if r.status_code != 200:
        return JsonResponse({
            "status": "error",
            "message": r.text}, status=r.status_code)

    query = r.get("data")[0]

    engine = connect_sql_db('postgresql', username, password, hostname, database)
    

    engine = connect_sql_db('postgresql', username, password, hostname, database)
    cursor = engine.raw_connection().cursor()
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    engine.close()"""

    return JsonResponse({
        "query": query,
        # "data": result
    })


# a function that takes the schema and the names of tables
# in our case there will be one type of table schema
def get_table_info(engine):
    # take the connection to database

    cursor = engine.raw_connection().cursor()

    query = "SELECT table_schema, table_name " \
            "FROM information_schema.tables " \
            "WHERE table_schema != 'pg_catalog' " \
            "AND table_type != 'information_schema' " \
            "Order by table_schema, table_name "
    cursor.execute(query)
    tables = cursor.fetchall()
    cursor.close()
    return tables


def get_column_info(engine, schema, table):
    cursor = engine.raw_connection().cursor()

    query = "SELECT column_name " \
            "FROM information_schema.columns " \
            "WHERE table_schema = %s And table_name = %s " \
            "ORDER BY ordinal_position" % (schema, table)
    cursor.execute(query)
    columns = cursor.fetchall()
    cursor.close()
    return columns

# this function is returning the string to frontend for storage and it will be required for the get_sql_function
def database_info(request):
    # this will most likely will be a put method but for now it will stay as post
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    port = data.get("port")
    #port = 5430
    hostname = data.get("server")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")

    engine = connect_sql_db('postgresql', username, password, hostname, database)

    tables = get_table_info(engine)

    for table in tables:
        table["columns"] = get_column_info(engine, table["table_schema"], table["table_name"])

    engine.close()

    db_info_string = " | concert_singer | "
    for table in tables:
        db_info_string += table["table_name"] + " : "
        for column in table["columns"]:
            db_info_string += column["column_name"] + ", "
        db_info_string = db_info_string[:-2]
        db_info_string += " | "
    db_info_string = db_info_string[:-3]
    print(db_info_string)
    return db_info_string
