# grouper_training
A set of Grouper images that are used during I2/TIER training.

# Images

## Full Demo

```
docker run -d -p 389:389 -p 8443:443 -p 3306:3306 \
  --name grouper-demo tier/grouper-training-env:full_demo
```

Browse to `https://localhost/grouper`

## Exercises

```
docker run -d -p 80:80 -p 389:389 -p 8443:443 -p 3306:3306 \
  --name gte tier/grouper-training-env:exXXX
```

Current tags:
- ex101.1.1
- ex201.1.1
- ex201.1.end
- ex201.2.1
- ex201.2.end
- ex201.3.1
- ex201.3.end
- ex201.4.1
- ex201.4.end
- ex201.5.1
- ex201.5.end
- ex211.1.1
- ex301.4.1
- ex401.1.1
- ex401.1.2
- ex401.1.3
- ex401.1.4
- ex401.1.5
- ex401.1.6
- ex401.1.end
- ex401.2.1
- ex401.2.2
- ex401.2.3
- ex401.2.4
- ex401.2.5
- ex401.2.6
- ex401.2.7
- ex401.2.8
- ex401.2.9
- ex401.2.end
- ex401.3.1
- ex401.3.2
- ex401.3.3
- ex401.3.4
- ex401.3.5
- ex401.3.6
- ex401.3.7
- ex401.3.end
- ex401.4.1
- ex401.4.end

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
  --link rabbitmq:rabbitmq --name gte tier/grouper-training-env:exXXX

```
