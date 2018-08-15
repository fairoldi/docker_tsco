FROM centos:7
EXPOSE 8043:8043/tcp
EXPOSE 8048:8048/tcp

WORKDIR /opt
COPY ./tsso.conf /opt
COPY ./tsps.conf /opt
COPY ./install.sh /opt
WORKDIR /opt/installers
COPY ./Remedy_Single_Sign-On_for_TrueSight_Version_11.3.01_Linux.tar.gz /opt/installers
COPY ./TrueSight_Presentation_Server_11.3.01_Linux.tar.gz /opt/installers
CMD /opt/install.sh
