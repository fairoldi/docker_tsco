FROM centos:7
EXPOSE 8048:8048/tcp

WORKDIR /opt
COPY ./tsso.conf /opt/
COPY ./*.sh /opt/
RUN chmod a+rx /opt/*.sh
WORKDIR /opt/installers
COPY ./Remedy_Single_Sign-On_for_TrueSight_Version_11.0_Linux.tar.gz /opt/installers
CMD /opt/install.sh
