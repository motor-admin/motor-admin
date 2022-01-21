# Getting Started

## Docker

```bash
docker run -it -p 3000:3000 -v `pwd`:/app motoradmin/motoradmin:latest
```

### Docker Compose

```bash
curl https://raw.githubusercontent.com/motor-admin/motor-admin/master/docker-compose.yml  | sed "s/SECRET_KEY_BASE:/SECRET_KEY_BASE: `openssl rand -hex 64`/" > docker-compose.yml

docker compose up
```

## Ubuntu

```bash
curl -o motor-admin -L https://github.com/motor-admin/motor-admin/releases/download/latest/motor-admin-Linux-x86_64
sudo chmod +x ./motor-admin
./motor-admin
```

## MacOS

```bash
curl -o motor-admin -L https://github.com/motor-admin/motor-admin/releases/download/latest/motor-admin-Darwin-x86_64
chmod +x ./motor-admin
./motor-admin
```

## Heroku

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/motor-admin/motor-admin-heroku)
