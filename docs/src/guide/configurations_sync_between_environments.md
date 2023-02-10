# Configurations Sync

All admin panel configurations are automatically stored in the `motor-admin.yml` file. It's recommended to include this file in the application git repository to always have the admin panel configurations in sync across different local and remote environments. Configurations from the `motor-admin.yml` file are loaded automatically each time the file changes via `git push` or `rsync`.

It's possible to sync local development admin panel configurations with remote production application via `rake motor:sync` task:

```bash
MOTOR_SYNC_REMOTE_URL=https://remote-app-url/ MOTOR_SYNC_API_KEY=secure-random-string ./motor-admin sync
```

### Docker Git

Docker container should be run with mounted volume in order to access `motor-admin.yml` configs file for git version control:

```bash
docker run --rm -it -p 3000:3000 -v `pwd`:/app motoradmin/motoradmin:latest
```

### Docker Sync

```bash
docker run --rm -it -e MOTOR_SYNC_REMOTE_URL=https://remote-app-url/ -e MOTOR_SYNC_API_KEY=secure-random-string motoradmin/motoradmin:latest motor-admin sync
```

### Docker Compose Sync

```bash
docker compose run app motor-admin sync
```
