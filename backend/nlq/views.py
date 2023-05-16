from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
import json
import requests
import psycopg2
import psycopg2.extras
from .utils import connect_sql_db, get_sql, database_info, connect_nosql_db
from django.views.decorators.csrf import csrf_exempt


# Create your views here.

@csrf_exempt
def get_sql_query(request):
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    input_sentence = data.get("input")

    if input_sentence is None:
        return JsonResponse(
            {"status": "error", "message": "Input is required"}, status=404)

    port = data.get("port")
    hostname = data.get("hostname")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")
    database_type = data.get("database_type")
    db_info = database_info(database_type, username, password, hostname, database)

    query = get_sql(input_sentence + db_info)
    query = query[:-4]
    query = query[query.find("select"):]

    return JsonResponse({
        "query": query
    })


@csrf_exempt
def get_query_result(request):
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    query = data.get("query")
    hostname = data.get("hostname")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")
    database_type = data.get("database_type")

    try:
        engine = connect_sql_db(database_type, username, password, hostname, database)
        connection = engine.connect()
        result = connection.execute(f"select a.* from ({query}) a limit 1000")

        columns = [col for col in result.keys()]
        data = [list(res) for res in result.fetchall()]

        # print(type(data), type(data[0]))
        response = {
            "success": True,
            "columns": columns,
            "data": data
        }
        return JsonResponse(response)
    except Exception as e:
        print(e)
        response = {
            "success": False,
            "columns": [],
            "data": []
        }
        return JsonResponse(response)


# Will change
def nosql_query(request):
    # After  checking with talha this function will be changed to something similar in text_ada_mongo.ipynb
    # I require more insight to functionalities of openai
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    #    collection = data.get("collection")
    hostname = data.get("hostname")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")
    database_type = data.get("database_type")
    # will change
    db_info = database_info(database_type, username, password, hostname, database)
    # collection = db.<coll_name> collections are like tables

    # there will be a query generator here
    # will use openai api like talhas submit in the last issue
    return JsonResponse({
        "query": "query"
    })


def nosql_query_result(request):
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    query = data.get("query")
    hostname = data.get("hostname")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")
    database_type = data.get("database_type")

    try:
        db = connect_nosql_db(database_type, username, password, hostname, database)
        result = db.find(query)

        # print(type(data), type(data[0]))
        response = {
            "success": True,
            "result": result
        }
        return JsonResponse(response)
    except Exception as e:
        print(e)
        response = {
            "success": False,
            "result": []
        }
        return JsonResponse(response)
