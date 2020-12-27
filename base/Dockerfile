FROM openjdk:8 AS sparkbuild

ENV SPARK_VERSION=3.0.1
ENV HADOOP_VERSION=3.2.1

ARG SPARK_BUILD_NAME='without-hadoop'
ARG SPARK_BUILD_PROFILES='-Phive -Phive-thriftserver -Pyarn -Phadoop-provided -Dhadoop.version=3.2.1'

ARG SPARK_SOURCE=/tmp/spark/src
ARG SPARK_SRC_URL=https://github.com/apache/spark/archive/v${SPARK_VERSION}.tar.gz

RUN mkdir -p ${SPARK_SOURCE} \
    && curl -sL ${SPARK_SRC_URL} | tar -xz -C ${SPARK_SOURCE} --strip-component=1 \
    && cd ${SPARK_SOURCE} \
    && ./dev/make-distribution.sh --name ${SPARK_BUILD_NAME} --tgz ${SPARK_BUILD_PROFILES}

FROM python:3.7-alpine

LABEL maintainer="Gezim Sejdiu <g.sejdiu@gmail.com>, Giannis Mouchakis <gmouchakis@gmail.com>, Guido Schmutz <guido.schmutz@gmail.com>"


ENV SPARK_SOURCE=/tmp/spark/src
ENV ENABLE_INIT_DAEMON true
ENV INIT_DAEMON_BASE_URI http://identifier/init-daemon
ENV INIT_DAEMON_STEP spark_master_init

ENV SPARK_VERSION=3.0.1
ENV HADOOP_VERSION=3.2.1
ENV HIVE_VERSION=2.3.7

COPY --from=sparkbuild ${SPARK_SOURCE}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz .

COPY wait-for-step.sh /
COPY execute-step.sh /
COPY finish-step.sh /

#COPY bde-spark.css /css/org/apache/spark/ui/static/timeline-view.css

# Setup Perl so that entrypoint.sh works
RUN apk add --update perl && rm -rf /var/cache/apk/*

RUN  wget https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
      && tar -xvf hadoop-${HADOOP_VERSION}.tar.gz -C /opt/ \
      && rm hadoop-${HADOOP_VERSION}.tar.gz \
      && cd /

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_HOME=$HADOOP_PREFIX
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV LD_LIBRARY_PATH=$HADOOP_PREFIX/lib/native
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH $HADOOP_PREFIX/bin/:$PATH
ENV SPARK_DIST_CLASSPATH=$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*

RUN apk add --no-cache curl bash gnupg wget openjdk8-jre nss libc6-compat \
      && ln -s /lib64/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2 \
      && chmod +x *.sh \
      && tar -xvzf spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
      && mv spark-${SPARK_VERSION}-bin-without-hadoop spark \
      && rm spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
      && wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz \
	  && tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz \
	  && mv apache-hive-$HIVE_VERSION-bin hive \
	  && rm apache-hive-$HIVE_VERSION-bin.tar.gz \
      && cd /

ENV JAVA_HOME /usr/lib/jvm/default-jvm/jre/

ENV SPARK_HOME /spark/
ENV PATH /spark/bin:$PATH

#Give permission to execute scripts
RUN chmod +x /wait-for-step.sh && chmod +x /execute-step.sh && chmod +x /finish-step.sh

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

COPY hive-site.xml /spark/conf/
COPY spark-env.sh /spark/conf/
COPY spark-defaults.conf /spark/conf/

#RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_VERSION}/aws-java-sdk-bundle-${AWS_VERSION}.jar -o /spark/jars/aws-java-sdk-bundle-${AWS_VERSION}.jar && \
#    curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar -o /spark/jars/hadoop-aws-${HADOOP_VERSION}.jar

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]


