ARG VERSION_TAG
FROM tier/gte:base-$VERSION_TAG

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper Training" \
      ImageName=$imagename \
      ImageOS=centos7

ENV USERTOKEN=gte-full-demo

COPY container_files/demo.gsh /seed-data/
COPY container_files/grouper-loader.properties /opt/grouper/conf/
COPY container_files/subject.properties /opt/grouper/conf/

RUN (/usr/sbin/slapd -h "ldap:/// ldaps:/// ldapi:///" -u ldap &) \
    && while ! curl -s ldap://localhost:389 > /dev/null; do echo waiting for ldap to start; sleep 1; done; \
    (mysqld_safe & ) \
    && while ! curl -s localhost:3306 > /dev/null; do echo waiting for mysqld to start; sleep 3; done; \
    . /usr/local/bin/library.sh \
    && prepConf \
    && cd /opt/grouper/grouper.apiBinary \
    && bin/gsh /seed-data/demo.gsh \
    && pkill -HUP slapd \
    && while curl -s ldap://localhost:389 > /dev/null; do echo waiting for ldap to stop; sleep 1; done; \
    pkill -u mysql mysqld \
    && while curl -s localhost:3306 > /dev/null; do echo waiting for mysqld to stop; sleep 1; done
