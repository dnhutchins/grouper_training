FROM tier/grouper_training_env:base

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper Training" \
      ImageName=$imagename \
      ImageOS=centos7

ENV USERTOKEN=3.2.0_ex2

COPY container_files/subject.properties /opt/grouper/conf
