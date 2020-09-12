FROM python:3.7-alpine

LABEL maintainer="Gezim Sejdiu <g.sejdiu@gmail.com>, Giannis Mouchakis <gmouchakis@gmail.com>, Guido Schmutz <guido.schmutz@gmail.com>"

ENV ENABLE_INIT_DAEMON true
ENV INIT_DAEMON_BASE_URI http://identifier/init-daemon
ENV INIT_DAEMON_STEP spark_master_init

ENV SPARK_VERSION=2.4.5
ENV HADOOP_VERSION=2.8.5
ENV HIVE_VERSION=2.3.3
ENV AWS_VERSION=1.11.271

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
      && wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
      && tar -xvzf spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
      && mv spark-${SPARK_VERSION}-bin-without-hadoop spark \
      && rm spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
      #&& cd /css \
      #&& jar uf /spark/jars/spark-core_2.11-${SPARK_VERSION}.jar org/apache/spark/ui/static/timeline-view.css \
      && wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
	  && tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
	  && mv apache-hive-$HIVE_VERSION-bin hive && \
	  && rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
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

RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_VERSION}/aws-java-sdk-bundle-${AWS_VERSION}.jar -o /spark/jars/aws-java-sdk.jar && \
    curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar -o /spark/jars/hadoop-aws.jar

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]


