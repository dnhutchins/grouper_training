ARG VERSION_TAG
FROM tier/gte:401.1.4-$VERSION_TAG

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper Training" \
      ImageName=$imagename \
      ImageOS=centos7

ENV USERTOKEN=gte-401.1.5

COPY container_files/seed-data/ /seed-data/

#  && setupFiles
RUN . /usr/local/bin/library.sh \
    && prep_conf && prep_finish; \
    (/usr/sbin/slapd -h "ldap:/// ldaps:/// ldapi:///" -u ldap &) \
    && while ! curl -s ldap://localhost:389 > /dev/null; do echo waiting for ldap to start; sleep 1; done; \
    (mysqld_safe & ) \
    && while ! curl -s localhost:3306 > /dev/null; do echo waiting for mysqld to start; sleep 3; done; \
    cd /opt/grouper/grouperWebapp/WEB-INF \
    && ldapadd -x -D cn=root,dc=internet2,dc=edu -w password -f /seed-data/users.ldif \
    && mysql grouper < /seed-data/sisData.sql \
    && if [ ! -f /usr/local/bin/java ]; then ln -s /usr/lib/jvm/java-1.8.0-amazon-corretto/bin/java /usr/local/bin/java; fi \
    && sudo --preserve-env=PATH -u tomcat bin/gsh.sh /seed-data/bootstrap.gsh \
    && pkill -HUP slapd \
    && while curl -s ldap://localhost:389 > /dev/null; do echo waiting for ldap to stop; sleep 1; done; \
    pkill -u mysql mysqld \
    && while curl -s localhost:3306 > /dev/null; do echo waiting for mysqld to stop; sleep 1; done
