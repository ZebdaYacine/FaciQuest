# FaciQuest admin dashboard — Flutter web, served by nginx.
#
# Two stages so the runtime image carries none of the ~1GB Flutter SDK: stage
# one compiles to static files, stage two is nginx plus that output.
#
# Build context is this directory (frontend/dashboard), not the repo root — the
# dashboard is a standalone Flutter package with its own pubspec, so nothing
# above it is needed.
#
# Config note: lib/services/app_config.dart reads everything through
# flutter_dotenv, and pubspec.yaml declares `.env` as an *asset*. That means the
# file is bundled into the compiled output at build time — same one-way door as
# NEXT_PUBLIC_* in a Next.js build. `.env` is gitignored, so it does not exist
# in the context; it is written here from build args. Repointing the API is a
# rebuild, not a restart.

# The SDK comes from Google's own release archive rather than a prebuilt Flutter
# image: cirrusci/flutter stopped publishing at 3.8 and ghcr.io/cirruslabs/flutter
# does not resolve, so neither can supply 3.44.2. Pinned by exact version — an
# unpinned SDK turns an unrelated Flutter release into a surprise failure on an
# unrelated commit.
#
# That archive is x64-only, which is why the workflow builds linux/amd64. On an
# arm64 machine a local `docker build` needs --platform linux/amd64 and qemu.
FROM debian:bookworm-slim AS build

ARG FLUTTER_VERSION=3.44.2

# Retries because a single dropped connection to the Debian mirror should not
# fail a deploy; the same goes for the SDK download below.
RUN apt-get update -o Acquire::Retries=3 \
    && apt-get install -y --no-install-recommends -o Acquire::Retries=3 \
      ca-certificates curl git unzip xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL --retry 3 --retry-delay 2 --retry-connrefused \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
      | tar -xJ -C /opt \
    && git config --global --add safe.directory /opt/flutter

ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Warm the SDK's own caches in their own layer, so they survive source edits.
RUN flutter --version && flutter config --no-analytics && flutter precache --web

WORKDIR /app

# Resolve dependencies against the lockfile alone first, so editing Dart source
# does not invalidate the (slow) pub get layer.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# Only API_BASE_URL is required. The rest have sane defaults in app_config.dart,
# but production wants them explicit — a dashboard shipped with DEBUG_MODE=true
# renders the debug banner and logs verbosely in a user's browser.
ARG API_BASE_URL
ARG APP_VERSION=1.0.0
ARG DEBUG_MODE=false
ARG LOG_LEVEL=info
ARG SHOW_DETAILED_ERRORS=false
ARG ANALYTICS_ENABLED=false
ARG ANALYTICS_TRACKING_ID=

# Guard rather than let it slide: an empty value here does not fail the build,
# it silently falls back to the hardcoded 185.209.230.104 default and every
# request from a real browser goes to the wrong host.
RUN test -n "$API_BASE_URL" || { echo "ERROR: API_BASE_URL build-arg is empty; the bundle would fall back to the hardcoded dev IP." >&2; exit 1; }

RUN printf '%s\n' \
      "API_BASE_URL=${API_BASE_URL}" \
      "API_TIMEOUT=30000" \
      "AUTH_TOKEN_KEY=dashboard_auth_token" \
      "AUTH_REFRESH_TOKEN_KEY=dashboard_refresh_token" \
      "APP_NAME=FaciQuest Admin Dashboard" \
      "APP_VERSION=${APP_VERSION}" \
      "DEBUG_MODE=${DEBUG_MODE}" \
      "DEFAULT_PAGE_SIZE=10" \
      "MAX_PAGE_SIZE=100" \
      "CACHE_DURATION_MINUTES=5" \
      "DEFAULT_THEME_COLOR=0xFF2196F3" \
      "ENABLE_RESPONSIVE_BREAKPOINTS=true" \
      "ANALYTICS_ENABLED=${ANALYTICS_ENABLED}" \
      "ANALYTICS_TRACKING_ID=${ANALYTICS_TRACKING_ID}" \
      "SHOW_DETAILED_ERRORS=${SHOW_DETAILED_ERRORS}" \
      "LOG_LEVEL=${LOG_LEVEL}" \
    > .env

RUN flutter build web --release --build-name="${APP_VERSION}"

# Prove the bake worked while we still have a shell and a failure is cheap. If
# this trips, the asset manifest changed and the app would silently run on
# defaults — much harder to spot from a white screen in production.
RUN grep -q "API_BASE_URL=${API_BASE_URL}" build/web/assets/.env

FROM nginx:1.27-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

# Dokploy/Traefik will not route to a container it believes is unhealthy, so the
# check has to be real rather than decorative.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz || exit 1
