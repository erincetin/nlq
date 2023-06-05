from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
import json
import requests
import psycopg2
import psycopg2.extras
from .utils import connect_sql_db, get_sql, database_info, connect_nosql_db, mongo_query_gen
from django.views.decorators.csrf import csrf_exempt

from sqlalchemy import create_engine, text
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

    tmp = query.split('"')
    query = "\'".join(tmp)

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
        result = connection.execute(text(f"select a.* from ({query}) a limit 1000"))

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


# get collection names to user since they may not have these
def get_nosql_collections(request):
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    hostname = data.get("hostname")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")
    database_type = data.get("database_type")
    try:
        client = connect_nosql_db(database_type, username, password, hostname, database)
        coll_names = client[database].list_collection_names()
        client.close()
        response = {
            "success": True,
            "result": coll_names
        }
        return JsonResponse(response)
    except Exception as e:
        print(e)
        response = {
            "success": False,
            "result": []
        }
        return JsonResponse(response)


@csrf_exempt
def get_nosql_query(request):
    if request.method != "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    question = data.get("question")
    hostname = data.get("hostname")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")
    collection = data.get("collection")
    database_type = data.get("database_type")

    query = mongo_query_gen(username, password, hostname, database, collection, question)

    return JsonResponse({
        "success": True,
        "query": query
    })


@csrf_exempt
def get_nosql_query_result(request):
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
    collection = data.get("collection")
    database_type = data.get("database_type")

    try:
        query = json.loads(query)
        client = connect_nosql_db(database_type, username, password, hostname, database)
        db = client[database]
        coll = db[collection]
        result = coll.find(query)

        query_result = []

        for res in result:
            res['_id'] = str(res['_id'])
            query_result.append(res)
        client.close()
        response = {
            "success": True,
            "result": query_result,
            "columns": list(query_result[0].keys()) if len(query) > 0 else []
        }
        return JsonResponse(response)

    except Exception as e:
        print(e)
        response = {
            "success": False,
            "result": []
        }
        return JsonResponse(response)
