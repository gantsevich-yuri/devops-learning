#!/bin/bash
set -e

until pg_isready -h db_master -p 5432 -U postgres; do
  sleep 2
done

echo "Master is ready, starting basebackup"

PGPASSWORD=P@ssw0rd pg_basebackup -h db_master -U replicator -p 5432 -D /var/lib/postgresql/data -Fp -Xs -P -R -S slave1 -C