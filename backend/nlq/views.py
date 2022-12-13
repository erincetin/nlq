from django.shortcuts import render
from django.http import JsonResponse, HttpResponse

# Create your views here.


def hello(response):
    return HttpResponse("Hello")


def get_sql_query(response):
    #Todo: Calculate query

    query = "SELECT * FROM X WHERE Y = Z"

    #Todo: get data

    data = {
        "header": ["Name", "Surname", "Age", "Department", "Year"],
        "data": [
            ["Ali", "Yılmaz", "22", "Computer Engineering", "4"],
            ["Mehmet", "Türkmen", "21", "Mechanical Engineering", "3"],
            ["Öykü", "Yıldız", "23", "Computer Engineering", "4"],
            ["Ekrem", "Çetin", "19", "Electric and Electronic Engineering", "1"],
            ["Gizem", "Yıldırım", "22", "Biology", "4"],
        ]
    }


    return JsonResponse({
        "query": query,
        "data": data
    })
