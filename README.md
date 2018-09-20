# grouper_training
A set of Grouper images that are used during I2/TIER training.

# Images

## Full Demo

```
docker run -d -p 80:80 -p 389:389 -p 443:443 -p 3306:3306 -p 4443:4443 \
  --name grouper-demo tier/grouper-training-env:full_demo
```

Browse to `https://localhost/grouper`

## Exercises

```
docker run -d -p 80:80 -p 389:389 -p 443:443 -p 3306:3306 -p 4443:4443 \
  --name gte tier/grouper-training-env:exXXX
```

Current tags:

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

Browse to `https://localhost/grouper` for Grouper. There is also an app that dumps the SP user attributes at `https://localhost/app`.

# Users
- `banderson`/`password`: Grouper Administrator
- `jsmith`/`password`: standard user
- additional users can be found in <https://github.internet2.edu/docker/grouper_training/blob/master/base/container_files/seed-data/users.ldif#L56>

# Help apps

- phpMyAdmin - https://localhost/phpmyadmin/ - username: `root`, password: (blank)
- phpLDAPadmin - https://localhost/phpldapadmin/ - username: `cn=root,dc=internet2,dc=edu`, password: `password`
