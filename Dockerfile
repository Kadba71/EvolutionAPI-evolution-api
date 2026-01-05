FROM evoapicloud/evolution-api:v1.8.7

# Expose port (image already listens on 8080)
EXPOSE 8080

# Use custom lightweight entry to normalize envs and start app
COPY docker-entry.sh /usr/local/bin/docker-entry.sh
RUN chmod +x /usr/local/bin/docker-entry.sh
## Ensure bash exists for upstream start.sh scripts on 1.8.x images
RUN set -eux; \
	if command -v apk >/dev/null 2>&1; then \
		apk add --no-cache bash; \
	elif command -v apt-get >/dev/null 2>&1; then \
		apt-get update; \
		apt-get install -y --no-install-recommends bash; \
		rm -rf /var/lib/apt/lists/*; \
	elif command -v microdnf >/dev/null 2>&1; then \
		microdnf install -y bash; \
	elif command -v yum >/dev/null 2>&1; then \
		yum install -y bash; \
	elif command -v dnf >/dev/null 2>&1; then \
		dnf install -y bash; \
	else \
		echo "No package manager detected; assuming bash already present"; \
	fi
ENTRYPOINT ["/usr/local/bin/docker-entry.sh"]
