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

## Heroku

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/motor-admin/motor-admin-heroku)

## Digital Ocean

[![Deploy on Digital Ocean](https://www.deploytodo.com/do-btn-blue.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/motor-admin/motor-admin/tree/master&refcode=33c75473a82d)

## Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https%3A%2F%2Fgithub.com%2Fmotor-admin%2Fmotor-admin-railway&plugins=postgresql&envs=SECRET_KEY_BASE&SECRET_KEY_BASEDesc=64+character+secret&PORTDefault=secret&referralCode=DSdLCm)
