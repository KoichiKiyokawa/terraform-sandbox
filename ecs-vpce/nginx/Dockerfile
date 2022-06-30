FROM nginx:1.17

RUN apt update && \
    apt install -y && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ARG APP_SERVER

COPY nginx.conf /etc/nginx/nginx.conf

COPY conf.d/default.conf.tmpl default.conf.tmpl
RUN cat default.conf.tmpl | envsubst > /etc/nginx/conf.d/default.conf

RUN cat /etc/nginx/conf.d/default.conf

EXPOSE 80
