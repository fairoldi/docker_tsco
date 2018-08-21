FROM wnameless/oracle-xe-11g
EXPOSE 1521:1521/tcp

COPY *.sql /docker-entrypoint-initdb.d/
RUN chmod a+r /docker-entrypoint-initdb.d/*.sql
RUN bash -c 'mkdir -pv /oradata/bco ; chown -R oracle:dba /oradata/bco'



