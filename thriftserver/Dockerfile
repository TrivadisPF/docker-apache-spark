FROM trivadis/apache-spark-base:3.0.1-hadoop3.2

LABEL maintainer="Guido Schmutz"

COPY thriftserver.sh /

ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_THRIFTSERVER_LOG /spark/logs

EXPOSE 4040 10000

CMD ["/bin/bash", "/thriftserver.sh"]
