from django.urls import path, include
from . import views

urlpatterns = [
    path('hello', views.hello),
    path('get-sql-query', views.get_sql_query),
    path('register-database', views.database_info),
]