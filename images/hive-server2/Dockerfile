# images/hive-metastore/Dockerfile
FROM bigdata-base:latest
COPY entrypoint.sh /entrypoint.sh
COPY ../../config/hive/hive-site.xml $HIVE_HOME/conf/
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]