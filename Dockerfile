FROM evoapicloud/evolution-api:v1.8.7

# Expose port (image already listens on 8080)
EXPOSE 8080

# Use custom lightweight entry to normalize envs and start app
COPY docker-entry.sh /usr/local/bin/docker-entry.sh
RUN chmod +x /usr/local/bin/docker-entry.sh
ENTRYPOINT ["/usr/local/bin/docker-entry.sh"]
