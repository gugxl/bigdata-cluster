#!/bin/bash
set -e
$HBASE_HOME/bin/start-hbase.sh
tail -f $HBASE_HOME/logs/*.log
