FROM python:3.12.2

WORKDIR /var/www

COPY . /var/www

RUN apt update -y
RUN apt install -y curl procps git

RUN pip install -r requirements.txt

CMD ./uwsgi.sh
