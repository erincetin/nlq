from django.shortcuts import render
from django.http import JsonResponse, HttpResponse

# Create your views here.


def hello(response):
    return HttpResponse("Hello")



