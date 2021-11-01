FROM ubuntu:latest

ENV RAILS_ENV=production

WORKDIR /opt

RUN apt update && apt install -y wget libsqlite3-dev

RUN wget -O motor-admin https://github.com/motor-admin/motor-admin/releases/download/latest/motor-admin-Linux-x86_64 && chmod +x ./motor-admin

CMD ["/opt/motor-admin"]
