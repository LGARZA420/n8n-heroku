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
      font-noto-emoji \
 && chown root:root /usr/lib/chromium/chrome-sandbox \
 && chmod 4755      /usr/lib/chromium/chrome-sandbox

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
ENTRYPOINT []

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
