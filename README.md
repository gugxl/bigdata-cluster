# bigdata-cluster
自己基于官方文件进行dockerFile构件然后基于docker compose进行整合


# Bigdata Cluster

This repository contains the Docker-based setup for a big data cluster including Hadoop 3.3.3, Hive 3.1.3, Spark 3.3.1, HBase 2.4.17, and ZooKeeper 3.7.

## Prerequisites

- Docker >= 20.10
- Docker Compose >= 1.25
- Git

## Directory Structure

```text
bigdata-cluster/
├── Dockerfile.base            # Base image with JDK, Hadoop, Hive, Spark, HBase
├── docker-compose.yml         # Compose file to start the full cluster
├── README.md                  # This file
├── config/                    # Configuration templates for each component
├── images/                    # Service-specific Dockerfiles and entrypoints
└── scripts/                   # Helper scripts (wait-for, format-nn, init-hdfs)
``` 

## Startup Order

1. **Build base image**
   ```bash
DOCKER_BUILDKIT=1 docker build -t bigdata-base:latest -f Dockerfile.base .
      ```

2. **Build service images**
   ```bash
   DOCKER_BUILDKIT=1 docker build -t bigdata-hive-metastore:latest ./images/hive-metastore
   DOCKER_BUILDKIT=1 docker build -t bigdata-hive-server2:latest ./images/hive-server2
   DOCKER_BUILDKIT=1 docker build -t bigdata-spark:latest ./images/spark-client
   DOCKER_BUILDKIT=1 docker build -t bigdata-hbase-master:latest ./images/hbase-master
   DOCKER_BUILDKIT=1 docker build -t bigdata-hbase-region:latest ./images/hbase-regionserver
   ```

3. **Start the cluster**
   ```bash
   docker-compose up -d
   ```

   The `docker-compose.yml` orchestrates the following sequence using `depends_on` and `wait-for.sh`:
    - **zookeeper** → **postgres** → **namenode** (format HDFS) → **datanode** → **resourcemanager** → **nodemanager** → **hive-metastore** → **hive-server2** → **spark-client** → **hbase-master** → **hbase-regionserver**

4. **Initialize HDFS directories (optional)**
   ```bash
   docker exec -it namenode /scripts/init-hdfs.sh
   ```

## Validation & Debugging

- **Check container logs**:
  ```bash
  docker-compose logs -f namenode
  ```

- **Access UIs**:
    - NameNode UI: http://localhost:9870
    - ResourceManager UI: http://localhost:8088
    - HiveServer2 Thrift: 10000
    - Spark UI: http://localhost:4040
    - HBase Master UI: http://localhost:16010

- **Test HDFS**:
  ```bash
  docker exec -it namenode hdfs dfs -ls /
  ```

- **Test Hive**:
  ```bash
  docker exec -it hive-server2 beeline -u "jdbc:hive2://hive-server2:10000"
  ```

- **Submit Spark job**:
  ```bash
  docker exec -it spark-client spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode client $SPARK_HOME/examples/jars/spark-examples_*.jar 10
  ```

- **Check HBase**:
  ```bash
  docker exec -it hbase-master hbase shell
  > list
  ```

## Stopping the cluster

```bash
docker-compose down
```
```
