<div align="center">

[![Motor Admin](https://user-images.githubusercontent.com/5418788/140520844-a947845d-b579-4b3f-9b49-c539ad3cf580.png)](https://www.getmotoradmin.com)

# Motor Admin

### No-code Admin Panel and Business Intelligence tool

🤓 [Live Demo](https://app.getmotoradmin.com/demo/) | 👀 [Features overview](https://www.youtube.com/watch?v=ZD4Six8ZEP8) | 📙 [Docs](https://docs.getmotoradmin.com/guide/) | 💬 [Discord](https://discord.com/invite/mFFJKSTgw3) | ⭐ [Pro](https://www.getmotoradmin.com/pro)
</div>

Search, create, update, and delete data entries using a convenient UI. Create complex custom actions like sending an automated email to your customers via API integration. Build custom reports with SQL and visualize the results with charts. Combine individual reports into a single dashboard and share it with your team.

## Deployment

### Heroku

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/motor-admin/motor-admin-heroku)

### Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https%3A%2F%2Fgithub.com%2Fmotor-admin%2Fmotor-admin-railway&plugins=postgresql&envs=SECRET_KEY_BASE&SECRET_KEY_BASEDesc=64+character+secret&PORTDefault=secret&referralCode=DSdLCm)

### Digital Ocean

[![Deploy on Digital Ocean](https://www.deploytodo.com/do-btn-blue.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/motor-admin/motor-admin/tree/master&refcode=33c75473a82d)

### Docker

```bash
docker run -it -p 3000:3000 -v `pwd`:/app motoradmin/motoradmin:latest
```

### Docker Compose

```bash
curl https://raw.githubusercontent.com/motor-admin/motor-admin/master/docker-compose.yml  | sed "s/SECRET_KEY_BASE:/SECRET_KEY_BASE: `openssl rand -hex 64`/" > docker-compose.yml

docker compose up
```

## Features

* [Customizable CRUD](#customizable-crud)
* [Custom actions](#custom-actions)
* [Forms builder](#forms-builder)
* [SQL queries](#sql-queries)
* [Data visualization](#data-visualization)
* [Dashboards](#dashboards)
* [Email alerts](#email-alerts)
* [Intelligence search](#intelligence-search)
* [Optimized for mobile](#optimized-for-mobile)
* [Configurations Sync](https://github.com/motor-admin/motor-admin/tree/master/guides/configurations_sync_between_environments.md)
* [Roles and permissions control](https://docs.getmotoradmin.com/guide/roles_and_permissions.html)
* Multiple databases support
* Audit log
* Personalized report alerts via Slack

## [Enterprise](https://www.getmotoradmin.com/pro)

* Multi-factor authentication
* SAML SSO
* Custom styling
* [learn more](https://www.getmotoradmin.com/pro)

### Customizable CRUD

![Resource settings](https://user-images.githubusercontent.com/5418788/119318569-2a840e80-bc82-11eb-9ba3-f3964eb6f997.png)

![Settings UI](https://user-images.githubusercontent.com/5418788/119263883-90708780-bbe9-11eb-9f9f-f76fed0b7f27.png)

### Custom Actions

![Custom actions](https://user-images.githubusercontent.com/5418788/119266132-3c1dd580-bbf2-11eb-9666-09e1640eaf7b.png)

### Forms Builder

![Custom form](https://user-images.githubusercontent.com/5418788/119264008-1391dd80-bbea-11eb-9f14-cb405e77fb60.png)

### SQL Queries

![SQL query](https://user-images.githubusercontent.com/5418788/119264127-84d19080-bbea-11eb-9903-ef465d1d2c97.png)

### Data Visualization

![motor-visualization](https://user-images.githubusercontent.com/5418788/119264625-a2075e80-bbec-11eb-986c-6106dd6e47ce.png)

### Dashboards

![Dashboard](https://user-images.githubusercontent.com/5418788/119264726-f579ac80-bbec-11eb-852e-8055f8aba200.png)

### Email Alerts

![Email alert](https://user-images.githubusercontent.com/5418788/119265049-feb74900-bbed-11eb-8070-bcc8d6113b9b.png)

### Intelligence Search

![Intelligence search](https://user-images.githubusercontent.com/5418788/119266559-eea26800-bbf3-11eb-8cb3-d0538aa386a9.png)

### Optimized for Mobile

![motor-mobile](https://user-images.githubusercontent.com/5418788/119269566-03392d00-bc01-11eb-9e9d-1f6a58fe0749.png)

## License

Motor Admin is licensed under the AGPL v3 license.
