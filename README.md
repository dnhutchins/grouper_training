# grouper_training
A set of Grouper images that are used during I2/TIER training.

# Images

## Full Demo

```
docker run -d -p 80:80 -p 389:389 -p 443:443 -p 3306:3306 -p 4443:4443 \
  --name grouper-demo tier/grouper_training_full_demo:latest
```

Browse to `https://localhost/grouper`

## Exercises

```
docker run -d -p 80:80 -p 389:389 -p 443:443 -p 3306:3306 -p 4443:4443 \
  --name grouper tier/grouper_training_ex###:latest
```

Browse to `https://localhost/grouper`

# Users
- `banderson`/`password`: Grouper Administrator
- `jsmith`/`password`: standard user
- additional users can be found in <https://github.internet2.edu/docker/grouper_training/blob/master/base/container_files/seed-data/users.ldif#L56>