FROM centos:7
EXPOSE 8043:8043/tcp

WORKDIR /opt
COPY ./tsps.conf /opt
COPY ./install.sh /opt
COPY ./wait-for-it.sh /opt
WORKDIR /opt/installers
COPY ./TrueSight_Presentation_Server_11.3.01_Linux.tar.gz /opt/installers
CMD /opt/install.sh
