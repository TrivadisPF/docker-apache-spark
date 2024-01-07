#!/bin/bash

TAG=3.5.0-hadoop3.3

cd base

docker build -t trivadis/apache-spark-base:${TAG} .

cd ../master

docker build -t trivadis/apache-spark-master:${TAG} .

cd ../worker

docker build -t trivadis/apache-spark-worker:${TAG} .

cd ../submit

docker build -t trivadis/apache-spark-submit:${TAG} .

cd ../thriftserver

docker build -t trivadis/apache-spark-thriftserver:${TAG} .

cd ../template/python

docker build -t trivadis/apache-spark-template-python:${TAG} .