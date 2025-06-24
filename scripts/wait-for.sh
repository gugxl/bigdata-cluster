#!/bin/bash
# Usage: ./wait-for.sh host:port [-t timeout]
set -e

hostport=$1
timeout=${2:-30}

host=${hostport%%:*}
port=${hostport##*:}

echo "Waiting for $host:$port ..."

for i in $(seq $timeout); do
  if nc -z $host $port; then
    echo "$host:$port is available!"
    exit 0
  fi
  sleep 1
done

echo "Timeout after $timeout seconds waiting for $host:$port"
exit 1
