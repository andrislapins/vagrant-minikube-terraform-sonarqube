#!/bin/bash
set -e

# This script will run when the MongoDB container is initialized

# Wait a bit to make sure MongoDB is fully started
sleep 5

# Restore the data from the existing backup
mongorestore --username $MONGO_INITDB_ROOT_USERNAME --password $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin --db movie-api-db /mongo-backup/movie-api-db/

echo "MongoDB data restored successfully from existing backup!"