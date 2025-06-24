#!/bin/bash
set -e
echo "Formatting HDFS NameNode..."
hdfs namenode -format -force
