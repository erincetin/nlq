#!/bin/bash

#pip3 freeze > requirements.txt

docker rmi -f $(docker images 'nlq_django' -a -q)
docker stop nlq
docker rm nlq
#rm nql_django.tar

docker build -t nlq_django .
docker run --name nlq -p 8000:8000 -d nlq_django

#docker save nql_django > nql_django.tar