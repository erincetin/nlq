from django.urls import path, include
from . import views

urlpatterns = [
    path('get-sql-query', views.get_sql_query),
    path('register-database', views.database_info),
    path('get-query-data', views.get_query_result),
    path('get-nosql-query', views.get_nosql_query),
    path('get-nosql-query-data', views.get_nosql_query_result),
]