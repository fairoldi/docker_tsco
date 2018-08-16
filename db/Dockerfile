FROM postgres:10
EXPOSE 5432:5432/tcp

COPY *.sql /docker-entrypoint-initdb.d/
RUN chmod a+r /docker-entrypoint-initdb.d/*.sql
RUN bash -c 'mkdir -pv /data/{BCO_DATA,BCO_DATA_IDX,BCO,BCO_IDX} ; chown -R postgres:postgres /data'



