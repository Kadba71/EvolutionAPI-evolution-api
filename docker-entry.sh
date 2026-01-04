#!/bin/sh
set -e

# If DATABASE_URL is not set but DATABASE_CONNECTION_URI is, map it
if [ -z "$DATABASE_URL" ] && [ -n "$DATABASE_CONNECTION_URI" ]; then
  export DATABASE_URL="$DATABASE_CONNECTION_URI"
fi

# Keep PORT and SERVER_PORT in sync (Railway uses PORT)
if [ -z "$SERVER_PORT" ] && [ -n "$PORT" ]; then
  export SERVER_PORT="$PORT"
fi
if [ -z "$PORT" ] && [ -n "$SERVER_PORT" ]; then
  export PORT="$SERVER_PORT"
fi

# Start application
exec npm run start:prod
