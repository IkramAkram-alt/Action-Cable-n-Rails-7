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
    #"$RAILS_CMD" db:create
    #"$RAILS_CMD" db:schema:load
    echo "in the database"
   "$RAILS_CMD" db:migrate:status 2>/dev/null || $RAILS_CMD db:create && $RAILS_CMD db:migrate
    
    #"$RAILS_CMD" db:seed
  else
    echo "running migration for $RAILS_ENV"
    #"$RAILS_CMD" db:migrate:ignore_concurrent
    #"$RAILS_CMD" db:create
    #"$RAILS_CMD" db:schema:load
    "$RAILS_CMD" db:migrate
    #"$RAILS_CMD" db:seed
    #"$RAILS_CMD" assets:precompile
  fi
}

install_bundle() {
  # bundle install
  echo "doing bundle install"
  bundle install
}



boot_server() {

    echo "*********** Running application on port 3000 ***********"
    "$RAILS_CMD" s --binding 0.0.0.0 -p 3001
}

main() {
  # tail -f log/development.log
  echo "bootstrapping dependencies"
  rm tmp/pids/server.pid || true
  #install_nodejs
  # install_node_modules
  install_bundle
  configure_db

  #run cron tasks
  # run_cron
  # run the rails server
  echo "starting server"
  boot_server
}
main