FROM tier/grouper_training_base:latest

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper Training" \
      ImageName=$imagename \
      ImageOS=centos7

COPY container_files/subject.properties /opt/grouper/conf

RUN . /usr/local/bin/library.sh \
    && prepDaemon \
    && prepUI \
    && prepWS
