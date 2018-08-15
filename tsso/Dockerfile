FROM centos:7
EXPOSE 8048:8048/tcp

WORKDIR /opt
COPY ./tsso.conf /opt/
COPY ./*.sh /opt/
WORKDIR /opt/installers
COPY ./Remedy_Single_Sign-On_for_TrueSight_Version_11.3.01_Linux.tar.gz /opt/installers
CMD /opt/install.sh
