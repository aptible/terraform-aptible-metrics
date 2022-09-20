#!/bin/bash

set -e

if [[ "$#" -ne 5 ]]; then
  echo "Wrong number of arguments ($# instead of 5)"
  echo "Usage: $0 env_handle db_handle db_url grafana_user grafana_password"
  exit 1
fi

parse_url() {
  # cf http://stackoverflow.com/a/17287984
  protocol="$(echo "$1" | grep :// | sed -e's,^\(.*://\).*,\1,g')"
  # remove the protocol
  url=$(echo $1 | sed -e s,$protocol,,g)
  # extract the user and password (if any)
  user_and_password="$(echo $url | grep @ | cut -d@ -f1)"
  password="$(echo $user_and_password | grep : | cut -d: -f2)"
  if [ -n "$password" ]; then
    user="$(echo $user_and_password | grep : | cut -d: -f1)"
  else
    user="$user_and_password"
  fi

  # extract the host
  host_and_port="$(echo $url | sed -e s,$user_and_password@,,g | cut -d/ -f1)"
  port="$(echo $host_and_port | grep : | cut -d: -f2)"
  if [ -n "$port" ]; then
    host="$(echo $host_and_port | grep : | cut -d: -f1)"
  else
    host="$host_and_port"
  fi

  database="$(echo $url | grep / | cut -d/ -f2-)"
}

ENV_HANDLE="$1"
DB_HANDLE="$2"
DB_URL="$3"
GRAFANA_DB_USER="$4"
GRAFANA_DB_PASSWORD="$5"

# Tunnel into the postgresql database and execute commands from stdin
aptible db:tunnel "$DB_HANDLE" --environment "$ENV_HANDLE" --port 54321 &

parse_url "$DB_URL"
url="${protocol}${user}:${password}@localhost:54321/${database}"
sleep 5

until pg_isready -d "$url"; do
  echo "Waiting for tunnel to come up..." >&2
  sleep 2
done

psql "$url" <<EOF
    CREATE DATABASE sessions;
    \c sessions;
    CREATE TABLE IF NOT EXISTS session (
      key     CHAR(16) NOT NULL,
      data    BYTEA,
      expiry  INTEGER NOT NULL,
      PRIMARY KEY (key)
    );

    CREATE USER "${GRAFANA_DB_USER}" WITH PASSWORD '${GRAFANA_DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON DATABASE db, sessions to "${GRAFANA_DB_USER}";
EOF

# INT isn't working for some reason so kill the tunnel and the port forwarder child process separately
pkill -P $!
kill $!
