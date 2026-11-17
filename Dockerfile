# Tronbyt server for Railway: the official image, pinned by version and digest.
# Bump both the tag and the digest together, and add a CHANGELOG.md entry.
FROM ghcr.io/tronbyt/server:2.6.1@sha256:279af92ffaece6f2e7259fbfd8bd82487dc1135ba705727a2f8f27c2fa2a67b1

# The image is built FROM scratch (no shell), so settings are plain ENV lines.
# Everything the server keeps (SQLite database, app catalogue, firmware, uploads)
# lives under /app/data, which the template mounts as a Railway volume.
ENV DB_DSN=/app/data/tronbyt.db \
    DATA_DIR=/app/data \
    TRONBYT_PORT=8000 \
    PRODUCTION=true \
    ENABLE_USER_REGISTRATION=false \
    SINGLE_USER_AUTO_LOGIN=false \
    LOG_LEVEL=INFO

EXPOSE 8000

# Same start as the upstream image: /boot fixes ownership of /app/data,
# drops to uid 1000 and starts the server.
ENTRYPOINT ["/boot"]
CMD ["/app/tronbyt-server"]
