FROM python:3.9.1

WORKDIR /var/www

COPY . /var/www

RUN apt update -y
RUN apt install -y curl procps git

RUN pip install -r requirements.txt

CMD ./uwsgi.sh
