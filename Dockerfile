FROM node:20-alpine

# Install dependencies
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++ \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    giflib-dev \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# Set working directory
WORKDIR /evolution

# Clone Evolution API
RUN git clone https://github.com/EvolutionAPI/evolution-api.git .

# Install dependencies
RUN npm install

# Build application
RUN npm run build

# Expose port
EXPOSE 8080

# Set environment for Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Start application
CMD ["npm", "run", "start:prod"]
