FROM python:3.8
#FROM python:3.8-slim-buster

ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY . /app

RUN apt-get update

RUN apt-get upgrade -y

#RUN apt-get install gcc -y

#RUN apt-get -y install libldap2-dev libsasl2-dev

RUN pip3 install -r requirements.txt

EXPOSE 8000
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
