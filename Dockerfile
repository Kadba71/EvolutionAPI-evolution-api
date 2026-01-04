FROM atendai/evolution-api:v1.8.7

# Expose port (image already listens on 8080)
EXPOSE 8080

# Ensure bash is available for start script used by 1.8.x images
RUN apk add --no-cache bash

# Map env vars at runtime to satisfy Prisma expectations
COPY docker-entry.sh /docker-entry.sh
ENTRYPOINT ["/bin/sh", "/docker-entry.sh"]
