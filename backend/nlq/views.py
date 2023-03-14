from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
import json
import requests
import psycopg2
import psycopg2.extras
from .utils import connect_sql_db, get_sql, postgresql_info, mysql_mssql_info, oracle_info
from django.views.decorators.csrf import csrf_exempt

db_string = ""


# Create your views here.

@csrf_exempt
def get_sql_query(request):
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    input_sentence = data.get("input")
    port = data.get("port")
    hostname = data.get("server")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")
    db_info = data.get("db_info")

    if input_sentence is None:
        return JsonResponse(
            {"status": "error", "message": "Input is required"}, status=404)

    query = get_sql(input_sentence + db_info)
    query = query[:-4]
    query = query[query.find("select"):]

    """r = requests.post("https://015346d8-f7ef-47f9.gradio.live/run/predict",
                      json={  # url will be changed according to colab link
                          "data": [input_sentence, db_info]}).json()
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


# this function is returning the string to frontend for storage, and it will be required for the get_sql_function
def database_info(request):
    # this will most likely will be a put method but for now it will stay as post
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )
    global db_string
    db_info = ''
    data = json.loads(request.body)
    port = data.get("port")
    # port = 5430
    hostname = data.get("server")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")
    db_type = data.get("db_type")

    if db_type == 'mysql':
        db_info = mysql_mssql_info(username, password, hostname, database, 0)
    elif db_type == 'postgresql':
        db_info = postgresql_info(username, password, hostname, database)
    elif db_type == 'mssql':
        db_info = mysql_mssql_info(username, password, hostname, database, 1)
    elif db_type == 'oracle':
        db_info = oracle_info(username, password, hostname, database)
    global db_string
    db_string = db_info


def disconnect_db():
    global db_string
    db_string = ""
