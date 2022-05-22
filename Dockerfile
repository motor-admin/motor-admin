FROM ubuntu:20.04

ENV RAILS_ENV=production

VOLUME ["/app"]

WORKDIR /app

RUN apt update && apt install -y wget libsqlite3-dev libmysqlclient-dev libpq-dev freetds-dev && rm -rf /var/lib/apt/lists/*

RUN wget -O motor-admin https://github.com/motor-admin/motor-admin/releases/download/latest/motor-admin-Linux-$(uname -m) && chmod +x ./motor-admin && mv ./motor-admin /usr/bin

EXPOSE 3000

CMD ["/bin/sh" , "-c" , "cd /app && motor-admin"]
