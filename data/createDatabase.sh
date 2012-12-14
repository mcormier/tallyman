#!/bin/bash

# Guarantee the current working directory
# is the same as the script location
SCRIPTLOC=`dirname $0`
cd $SCRIPTLOC

# Get database name from configuration file
DATABASE_LOC=`${SCRIPTLOC}/../bin/getProperty dbName`

if [ -e $DATABASE_LOC ] ; then
  echo "Database $DATABASE_LOC already exists!"
  echo "No reason to create database.  Exiting..."
  exit 1
fi

sqlite3 $DATABASE_LOC < createDatabase.sql

