FROM unicon/shibboleth-idp:3.3.3 as idp 

FROM tier/grouper:2.4.0-a0-u0-w0-p0-test

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper Training" \
      ImageName=$imagename \
      ImageOS=centos7

ENV ENV=training \
    USERTOKEN=3.2.0_base

RUN yum install -y epel-release \
    && yum install -y mariadb mariadb-server openldap openldap-clients openldap-servers phpMyAdmin phpldapadmin \
    && yum clean all

COPY container_files/seed-data/ /seed-data/

RUN mysql_install_db \
    && chown -R mysql:mysql /var/lib/mysql/ \
    && sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/my.cnf \
    && sed -i 's/^\(log_error\s.*\)/# \1/' /etc/my.cnf \
    && sed -i 's/\[mysqld\]/\[mysqld\]\ncharacter_set_server = utf8/' /etc/my.cnf \
    && sed -i 's/\[mysqld\]/\[mysqld\]\ncollation_server = utf8_general_ci/' /etc/my.cnf \
    && sed -i 's/\[mysqld\]/\[mysqld\]\nport = 3306/' /etc/my.cnf \
    && cat  /etc/my.cnf \
    && echo "/usr/bin/mysqld_safe &" > /tmp/config \
    && echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config \
    && echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config \
    && echo "mysql -e 'CREATE DATABASE grouper CHARACTER SET utf8 COLLATE utf8_bin;'" >> /tmp/config \
    && bash /tmp/config \
    && rm -f /tmp/config
#    && mysql grouper < /seed-data/sisData.sql

RUN cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG \
    && mkdir -p /var/ldap/example \
    && chown -R ldap:ldap /var/lib/ldap /etc/openldap/slapd.d /var/ldap \
    && (/usr/sbin/slapd -h "ldap:/// ldaps:/// ldapi:///" -u ldap &) \
    && while ! curl -s ldap://localhost:389 > /dev/null; do echo waiting for ldap to start; sleep 1; done; \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /seed-data/domain.ldif \
    && ldapadd -H ldapi:/// -f /etc/openldap/schema/cosine.ldif \
    && ldapadd -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif \
    && ldapadd -H ldapi:/// -f /seed-data/memberOf.ldif \
    && ldapadd -H ldapi:/// -f /seed-data/eduPerson.ldif \
    && ldapadd -x -D cn=root,dc=internet2,dc=edu -w password -f /seed-data/users.ldif \
    && pkill -HUP slapd \
    && while curl -s ldap://localhost:389 > /dev/null; do echo waiting for ldap to stop; sleep 1; done

COPY container_files/conf/* /opt/grouper/grouper.apiBinary/conf/

RUN (/usr/sbin/slapd -h "ldap:/// ldaps:/// ldapi:///" -u ldap &) \
    && while ! curl -s ldap://localhost:389 > /dev/null; do echo waiting for ldap to start; sleep 1; done; \
    (mysqld_safe & ) \
    && while ! curl -s localhost:3306 > /dev/null; do echo waiting for mysqld to start; sleep 3; done; \
    cd /opt/grouper/grouper.apiBinary \
    && bin/gsh -registry -check -runscript -noprompt \
    && bin/gsh /seed-data/bootstrap.gsh \
    && pkill -HUP slapd \
    && while curl -s ldap://localhost:389 > /dev/null; do echo waiting for ldap to stop; sleep 1; done; \
    pkill -u mysql mysqld \
    && while curl -s localhost:3306 > /dev/null; do echo waiting for mysqld to stop; sleep 1; done

COPY --from=idp /opt/shibboleth-idp/ /opt/shibboleth-idp/

COPY container_files/etc/ /etc/
COPY container_files/conf/ /opt/grouper/conf/
COPY container_files/httpd/* /etc/httpd/conf.d/
COPY container_files/shibboleth-idp/ /opt/shibboleth-idp/
COPY container_files/shibboleth-sp/* /etc/shibboleth/
COPY container_files/tomcat/ /opt/tomcat/
COPY container_files/tier-support/* /opt/tier-support/
COPY container_files/tls/host-key.pem  /etc/pki/tls/private/
COPY container_files/tls/* /etc/pki/tls/certs/
#COPY container_files/ui/* /opt/grouper/grouper.ui/WEB-INF/
COPY container_files/usr-local-bin/* /usr/local/bin/
COPY container_files/var-www-html/ /var/www/html/

RUN cp /opt/tier-support/grouper.xml /opt/tier-support/grouper-ws.xml /opt/tomcat/conf/Catalina/localhost/ \
    && chown -R tomcat /opt/shibboleth-idp/ \
    && chmod -R 700 /opt/shibboleth-idp/ \
    && chmod +rx /var/www/html/app/index.py

EXPOSE 389 3306 4443

CMD ["grouper"]