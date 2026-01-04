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

# If still empty, try building from PG* vars commonly provided by providers
if [ -z "$DATABASE_CONNECTION_URI" ] && [ -n "$PGHOST" ] && [ -n "$PGUSER" ] && [ -n "$PGPASSWORD" ] && [ -n "$PGDATABASE" ]; then
  PORT_SEGMENT="${PGPORT:-5432}"
  export DATABASE_CONNECTION_URI="postgresql://$PGUSER:$PGPASSWORD@$PGHOST:$PORT_SEGMENT/$PGDATABASE"
  export DATABASE_URL="$DATABASE_CONNECTION_URI"
fi

# Enforce TLS if not explicitly set and host is external
case "$DATABASE_CONNECTION_URI" in
  *sslmode=*) ;;
  *)
    if echo "$DATABASE_CONNECTION_URI" | grep -qE "postgresql://"; then
      export DATABASE_CONNECTION_URI="${DATABASE_CONNECTION_URI}?sslmode=require"
      export DATABASE_URL="$DATABASE_CONNECTION_URI"
    fi
    ;;
esac

# Log chosen datasource for easier debugging
echo "Resolved Prisma datasource: $DATABASE_CONNECTION_URI"

# Apply Prisma migrations to create missing tables (Instance, etc.)
echo "Running Prisma migrations..."
if command -v npx >/dev/null 2>&1; then
  # Try deploy; if no migrations, fall back to db push
  npx prisma migrate deploy || npx prisma db push || true
  # Ensure client is generated for the current schema
  npx prisma generate || true
else
  echo "npx not available; skipping Prisma CLI"
fi

# Keep PORT and SERVER_PORT in sync (Railway uses PORT)
if [ -z "$SERVER_PORT" ] && [ -n "$PORT" ]; then
  export SERVER_PORT="$PORT"
fi
if [ -z "$PORT" ] && [ -n "$SERVER_PORT" ]; then
  export PORT="$SERVER_PORT"
fi

# Ensure any packaged .env does not override Railway variables
rm -f .env || true
rm -f /evolution/.env || true
cd /evolution || true

# Start application
exec npm run start:prod
