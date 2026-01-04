#!/bin/sh
set -e

# Map Prisma envs both ways to avoid empty var issues
# Prefer DATABASE_CONNECTION_URI when present; otherwise fall back to DATABASE_URL
if [ -z "$DATABASE_CONNECTION_URI" ] && [ -n "$DATABASE_URL" ]; then
  export DATABASE_CONNECTION_URI="$DATABASE_URL"
fi
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
