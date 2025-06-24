# images/hive-metastore/entrypoint.sh
#!/bin/bash
set -e
if [ "$INIT_SCHEMA" == "true" ]; then
  schematool -dbType postgres -initSchema || true
fi
hive --service metastore

# images/hive-server2/Dockerfile
FROM bigdata-base:latest
COPY entrypoint.sh /entrypoint.sh
COPY ../../config/hive/hive-site.xml $HIVE_HOME/conf/
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

# images/hive-server2/entrypoint.sh
#!/bin/bash
set -e
hive --service hiveserver2

# images/spark-client/Dockerfile
FROM bigdata-base:latest
COPY entrypoint.sh /entrypoint.sh
COPY ../../config/spark/spark-defaults.conf $SPARK_HOME/conf/
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

# images/spark-client/entrypoint.sh
#!/bin/bash
set -e
exec bash