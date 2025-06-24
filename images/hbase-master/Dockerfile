FROM bigdata-base:latest
COPY entrypoint.sh /entrypoint.sh
COPY ../../config/hbase/hbase-site.xml $HBASE_HOME/conf/
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
