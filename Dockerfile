FROM evoapicloud/evolution-api:v1.8.7

# Expose port (image already listens on 8080)
EXPOSE 8080

# Use upstream image entrypoint/start. Environment mapping handled by Railway.
