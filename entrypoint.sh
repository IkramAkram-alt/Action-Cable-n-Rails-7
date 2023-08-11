#!/bin/bash

# exit if ret status not 0
set -o errexit

readonly RAILS_CMD="$(pwd)/bin/rails"
readonly BASHRC="$HOME"/.bashrc

source_rc() {
  . "$BASHRC"
}

configure_db() {
  echo "configuring DB for $RAILS_ENV runtime"
  if [ "$RAILS_ENV" = "development" ]; then
    "$RAILS_CMD" db:migrate:status 2>/dev/null || $RAILS_CMD db:create && $RAILS_CMD db:migrate
  else
    "$RAILS_CMD" db:migrate
  fi
}

install_bundle() {
  echo "doing bundle install"
  bundle install
}

start_redis() {
  echo "starting Redis server"
  redis-server --port 6400
}


boot_server() {
  echo "*********** Running application on port 3000 ***********"
  "$RAILS_CMD" s --binding 0.0.0.0 -p 3000
}

main() {
  echo "bootstrapping dependencies"
  rm tmp/pids/server.pid || true
  install_bundle
  configure_db
  start_redis &
  echo "starting server"
  boot_server
}

main
