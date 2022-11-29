#!/bin/bash

pip3 freeze > requirements.txt

docker rmi -f $(docker images 'nql_django' -a -q)

rm nql_django.tar

docker build -t nql_django .

docker save nql_django > nql_django.tar