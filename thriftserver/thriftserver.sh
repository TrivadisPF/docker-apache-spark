#!/bin/bash

# export SPARK_MASTER_HOST=`hostname`

. "/spark/sbin/spark-config.sh"

. "/spark/bin/load-spark-env.sh"

mkdir -p $SPARK_THRIFTSERVER_LOG

export SPARK_HOME=/spark
export CLASS="org.apache.spark.sql.hive.thriftserver.HiveThriftServer2"

ln -sf /dev/stdout /spark/logs/spark-root-org.apache.spark.sql.hive.thriftserver.HiveThriftServer2-1-$SPARK_MASTER_HOST.out

cd /spark/bin && /spark/bin/spark-submit --class $CLASS 1 --master $SPARK_MASTER --name "Thrift JDBC/ODBC Server" "$@" >> $SPARK_THRIFTSERVER_LOG/spark-thriftserver.out
