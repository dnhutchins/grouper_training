# Grouper Training Environment (gte)
The gte is a set of docker images that contain all the software components, configuration, and setup neccesary to complete the InCommon Grouper Training course. Each docker image tag coincides with a particular course, exercise, step, and the overall gte version. For example, the gte image tag for 101 Gouper Basics is 101.1.1-201906. The docker command to run the image for the 101 course is:
```
docker run -d -p 80:80 -p 389:389 -p 8443:443 -p 3306:3306 \
  --name gte-101.1.1 tier/gte:101.1.1-201906
```
This will start Grouper, a Shibboleth IdP, OpenLDAP, mySQL, and other components. It will take a little while for the container to get into a "Running" status. You can check that with this command:
```
docker ps --format "{{.Names}} {{.Status}}"
```
Once the container is in a `Running` state, browse to <https://localhost:8443/grouper> to access the Grouper UI and log in with one of the following:
- Grouper Administrator
  - username: `banderson`, password: `password`
- Normal User
  - username: `jsmith`, password: `password`

The container has a few other applications running. phpMyAdmin provides an admin interface to the Grouper mySQL database. phpLDAPadmin provides an admin interface to OpenLDAP. Finally, there is a sample application that displays subject attributes for the user that is logged in.
- phpMyAdmin <https://localhost:8443/phpmyadmin/>
  - username: `root`, password: (blank)
- phpLDAPadmin <https://localhost:8443/phpldapadmin/>
  - username: `cn=root,dc=internet2,dc=edu`, password: `password`
- Shibboleth SP subject attributes <https://localhost:8443/app>

All of the gte image tags are published to <https://hub.docker.com/r/tier/gte>. To use a particular image tag, run:
```
docker run -d -p 80:80 -p 389:389 -p 8443:443 -p 3306:3306 \
  --name {VERSION_TAG} tier/gte:{VERSION_TAG}
```
Where {VERSION_TAG} takes the form of {course}.{exercise}.{step}-{version}. For example:
```
docker run -d -p 80:80 -p 389:389 -p 8443:443 -p 3306:3306 \
  --name 101.1.1-201906 tier/gte:101.1.1-201906
```

More information about Grouper Training can be found on the Internet2 wiki: 
<https://spaces.at.internet2.edu/display/Grouper/Grouper+Training+Environment>.

# Rabbit MQ for 401 exercises
The 401 exercises require Rabbit MQ. Before starting the 401 docker images, start Rabbit MQ:
```
docker run -d -p 15672:15672 --env RABBITMQ_NODENAME=docker-rabbit \
  --hostname rabbitmq --name=rabbitmq rabbitmq:management
```

Then browse to <http://localhost:15672/> and login with `guest`/`guest`, and create a new queue named `grouper`.

Finally, start the 401 Grouper with this slightly modified command:
```
docker run -d -p 389:389 -p 8443:443 -p 3306:3306 \
  --link rabbitmq:rabbitmq --name tier/gte:401.{X.X|end}-201906
```
