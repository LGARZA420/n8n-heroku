# ──────────────────────────────────────────────────────────────
# 1. Base image
# ──────────────────────────────────────────────────────────────
FROM docker.n8n.io/n8nio/n8n

# ──────────────────────────────────────────────────────────────
# 2. Install Chromium & deps
# ──────────────────────────────────────────────────────────────
USER root

RUN apk add --no-cache \
      chromium \
      nss \
      glib \
      freetype \
      freetype-dev \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      udev \
      ttf-liberation \
      font-noto-emoji

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# ──────────────────────────────────────────────────────────────
# 3. Install n8n-nodes-puppeteer once, system-wide
# ──────────────────────────────────────────────────────────────
RUN mkdir -p /opt/n8n-custom-nodes && \
    cd /opt/n8n-custom-nodes && \
    npm install n8n-nodes-puppeteer && \
    chown -R node:node /opt/n8n-custom-nodes

# ──────────────────────────────────────────────────────────────
# 4. Copy **your** entrypoint and make it executable
# ──────────────────────────────────────────────────────────────
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    chown node:node /entrypoint.sh

# ──────────────────────────────────────────────────────────────
# 5. Drop back to non-root and set the entrypoint
# ──────────────────────────────────────────────────────────────
USER node
ENTRYPOINT ["/entrypoint.sh"]
