#!/bin/bash

# https://docs.docker.com/compose/rails/
# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

# Then exec the container's main process (CMD)
exec "$@"
