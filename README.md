# grouper_training
A set of Grouper images that are used during I2/TIER training.

# Images

## Full Demo

```
docker run -d -p 389:389 -p 8443:443 -p 3306:3306 \
  --name grouper-demo tier/gte:full_demo-201906
```

Browse to `https://localhost:8443/grouper`

## Exercises

```
docker run -d -p 80:80 -p 389:389 -p 8443:443 -p 3306:3306 \
  --name gte tier/gte:XXX.X.{X|end}-201906
```

Current tags:
- 101.1.1-201906
- 201.1.1-201906
- 201.1.end-201906
- 201.2.1-201906
- 201.2.end-201906
- 201.3.1-201906
- 201.3.end-201906
- 201.4.1-201906
- 201.4.end-201906
- 201.5.1-201906
- 201.5.end-201906
- 211.1.1-201906
- 301.4.1-201906
- 401.1.1-201906
- 401.1.2-201906
- 401.1.3-201906
- 401.1.4-201906
- 401.1.5-201906
- 401.1.6-201906
- 401.1.end-201906
- 401.2.1-201906
- 401.2.2-201906
- 401.2.3-201906
- 401.2.4-201906
- 401.2.5-201906
- 401.2.6-201906
- 401.2.7-201906
- 401.2.8-201906
- 401.2.9-201906
- 401.2.end-201906
- 401.3.1-201906
- 401.3.2-201906
- 401.3.3-201906
- 401.3.4-201906
- 401.3.5-201906
- 401.3.6-201906
- 401.3.7-201906
- 401.3.end-201906
- 401.4.1-201906
- 401.4.end-201906

Browse to `https://localhost:8443/grouper` for Grouper. There is also an app that dumps the SP user attributes at `https://localhost:8443/app`.

# Users
- `banderson`/`password`: Grouper Administrator
- `jsmith`/`password`: standard user
- additional users can be found in <https://github.internet2.edu/docker/grouper_training/blob/master/base/container_files/seed-data/users.ldif#L56>

# Help apps

- phpMyAdmin - https://localhost:8443/phpmyadmin/ - username: `root`, password: (blank)
- phpLDAPadmin - https://localhost:8443/phpldapadmin/ - username: `cn=root,dc=internet2,dc=edu`, password: `password`


# Course specific notes

## Notes for the exercises in 401

Before connecting to your SSH server, be sure to port forward a local port to the server's port `15672` as well.

These exercises require Rabbit MQ to be started. Before starting the ex401 Grouper container, run:

```
docker run -d -p 15672:15672 --env RABBITMQ_NODENAME=docker-rabbit --hostname rabbitmq --name=rabbitmq rabbitmq:management
```

Now browse to http://localhost:15672/ and login with `guest`/`guest`, and create a new queue named `grouper`.

Now start the ex401 Grouper with this slightly modified command:

```bash
docker run -d -p 389:389 -p 8443:443 -p 3306:3306 \
  --link rabbitmq:rabbitmq --name tier/gte:401.{X.X|end}-201906

```
