FROM trivadis/apache-spark-base:2.4.8-hadoop2.8

LABEL maintainer="Guido Schmutz"

COPY thriftserver.sh /

ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_THRIFTSERVER_LOG /spark/logs

EXPOSE 4040 10000

CMD ["/bin/bash", "/thriftserver.sh"]
