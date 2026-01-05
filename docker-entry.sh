#!/bin/sh
set -e

mask_uri() {
  # Mask password segment in URIs like scheme://user:password@host
  # Keep user/host visible, hide password to avoid leaking secrets in logs.
  printf '%s' "$1" | sed -E 's#(://[^:/?#]+):[^@/]+@#\1:***@#'
}

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
      if echo "$DATABASE_CONNECTION_URI" | grep -q "\?"; then
        export DATABASE_CONNECTION_URI="${DATABASE_CONNECTION_URI}&sslmode=require"
      else
        export DATABASE_CONNECTION_URI="${DATABASE_CONNECTION_URI}?sslmode=require"
      fi
      export DATABASE_URL="$DATABASE_CONNECTION_URI"
    fi
    ;;
esac

# Log chosen datasource for easier debugging
if [ -n "$DATABASE_CONNECTION_URI" ]; then
  echo "Resolved Prisma datasource: $(mask_uri "$DATABASE_CONNECTION_URI")"
else
  echo "Resolved Prisma datasource: (empty)"
fi

case "$(printf '%s' "${DATABASE_ENABLED:-}" | tr '[:upper:]' '[:lower:]')"" in
  false|0)
    :
    ;;
  *)
    if [ -z "$DATABASE_CONNECTION_URI" ] && [ -z "$DATABASE_URL" ]; then
      echo "Warning: DATABASE_ENABLED is not false, but no database URL is set (DATABASE_CONNECTION_URI/DATABASE_URL/PG*). DB-backed endpoints may fail."
    fi
    ;;
esac

# Respect DATABASE_ENABLED=false by disabling Prisma repository
case "$(printf '%s' "${DATABASE_ENABLED:-}" | tr '[:upper:]' '[:lower:]')" in
  false|0)
    echo "DATABASE_ENABLED=false → disabling Prisma repository"
    unset DATABASE_CONNECTION_URI
    unset DATABASE_URL
    ;;
esac

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
