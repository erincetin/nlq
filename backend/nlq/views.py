from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
import json
import requests
from utils import connect_sql_db
# Create your views here.


def hello(request):
    return HttpResponse("Hello")


def get_sql_query(request):
    if request.method == "POST":
        return JsonResponse(
            {"status": "error", "message": "Wrong method"}, status=405
        )

    data = json.loads(request.body)
    input_sentence = data.get("input")
    port = data.get("port")
    server = data.get("server")
    database = data.get("database")
    username = data.get("username")
    password = data.get("password")

    database_info = "| concert_singer | stadium : stadium_id, location, name, capacity, highest, lowest, average | " \
                    "singer : singer_id, name, country, song_name, song_release_year, age, is_male | concert : " \
                    "concert_id, concert_name, theme, stadium_id, year | singer_in_concert : concert_id, singer_id"
    if input_sentence is None:
        return JsonResponse(
            {"status": "error", "message": "Input is required"}, status=404)

    r = requests.post("https://a434edb2-d402-43d8.gradio.live/run/predict", json={ #url will be changed according to colab link
        "data": {"sentence": input_sentence,        #these can be changed back to hello world if they give errors
                 "db_info": database_info}}).json()

    if r.status_code != 200:
        return JsonResponse({
            "status": "error",
            "message": r.text}, status=r.status_code)

    query = r.get("data")[0]

    engine = connect_sql_db('postgresql', username, password, server, database)
    cursor = engine.raw_connection().cursor()
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    engine.close()

    return JsonResponse({
        "query": query,
        "data": result
    })
