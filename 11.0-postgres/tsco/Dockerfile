FROM centos:7
EXPOSE 8443:8443/tcp
EXPOSE 8280:8280/tcp
EXPOSE 10000-10200:10000-10200/tcp

WORKDIR /opt
COPY ./tsco.conf /opt/
COPY ./*.sh /opt/
RUN chmod a+rx /opt/*.sh
WORKDIR /opt/installers/
COPY ./TSCO_AppServer_ver11.0.00_Linux.tar.gz /opt/installers/
RUN yum -y install openssl perl
CMD /opt/install.sh




