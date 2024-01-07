#!/bin/bash

TAG=3.4.2-hadoop3.3

docker push trivadis/apache-spark-base:${TAG}
docker push trivadis/apache-spark-master:${TAG}
docker push trivadis/apache-spark-worker:${TAG}
docker push trivadis/apache-spark-submit:${TAG}
docker push trivadis/apache-spark-thriftserver:${TAG}
docker push trivadis/apache-spark-template-python:${TAG}