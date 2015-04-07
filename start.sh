#!/bin/bash

DATADIR="/var/lib/postgresql/9.4/main"
CONF="/etc/postgresql/9.4/main/postgresql.conf"
POSTGRES="/usr/lib/postgresql/9.4/bin/postgres"
INITDB="/usr/lib/postgresql/9.4/bin/initdb"

if [ ! -d $DATADIR ]; then
  echo "Creating Postgres data at $DATADIR"
  mkdir -p $DATADIR
fi

if [ ! "$(ls -A $DATADIR)" ]; then
  echo "Initializing Postgres Database at $DATADIR"
  chown -R postgres $DATADIR
  su postgres sh -c "$INITDB $DATADIR"
  su postgres sh -c "$POSTGRES --single -D $DATADIR -c config_file=$CONF" <<< "CREATE USER ntipa WITH SUPERUSER PASSWORD 'ntipa';"
 
fi
service postgresql start
echo "Creating Postgres DB for NTIPA"
su - postgres  -c  "createdb -O ntipa ntipa-manager" 
su - postgres  -c  "createdb -O ntipa ntipa-protocollo"
su - postgres  -c  "createdb -O ntipa ntipa-manager-dev"
su - postgres  -c  "createdb -O ntipa ntipa-protocollo-dev"
su - postgres  -c  "createdb -O ntipa ntipa-jbilling"
su - postgres  -c  "createdb -O ntipa ntipa-jbilling-dev" 
su - postgres  -c  "createdb -O ntipa ntipa-drupal" 
su - postgres  -c  "createdb -O ntipa ntipa-drupal-dev"
service postgresql stop

trap "echo \"Sending SIGTERM to postgres\"; killall -s SIGTERM postgres" SIGTERM
su postgres sh -c "$POSTGRES -D $DATADIR -c config_file=$CONF"
wait $!
