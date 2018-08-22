FROM centos:7
EXPOSE 8443:8443/tcp
EXPOSE 8280:8280/tcp
EXPOSE 10000-10200:10000-10200/tcp

WORKDIR /opt
COPY ./tsco.conf /opt/
COPY ./oracle_client.rsp /opt/
COPY ./*.sh /opt/
RUN chmod a+rx /opt/*.sh
WORKDIR /opt/installers/
COPY ./TSCO_AppServer_ver11.3.01_Linux.tar.gz /opt/installers/
COPY ./*.zip /opt/installers/
RUN yum -y install openssl perl unzip binutils.x86_64 compat-libcap1.x86_64 compat-libstdc++-33.i686 compat-libstdc++-33.x86_64 gcc.x86_64 gcc.x86_64 glibc.i686 glibc.x86_64 glibc.i686 glibc.x86_64 ksh libaio.i686 libaio.x86_64 libaio.i686 libaio.x86_64 libgcc.i686 libgcc.x86_64 libstdc++.i686 libstdc++.x86_64 libstdc++.i686 libstdc++.x86_64 libXi.i686 libXi.x86_64 libXtst.i686 libXtst.x86_64 make.x86_64 sysstat.x86_64 
CMD /opt/install.sh




