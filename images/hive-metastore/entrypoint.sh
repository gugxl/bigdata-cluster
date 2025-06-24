# images/hive-metastore/entrypoint.sh
#!/bin/bash
set -e
if [ "$INIT_SCHEMA" == "true" ]; then
  schematool -dbType postgres -initSchema || true
fi
hive --service metastore