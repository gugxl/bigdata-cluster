#!/bin/bash
set -e
$HBASE_HOME/bin/hbase-daemon.sh start regionserver
tail -f $HBASE_HOME/logs/*.log
