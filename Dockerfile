
# Stage 1: Prepare the website files
FROM alpine:3.20 AS builder

WORKDIR /app

COPY index.html .
COPY nginx.conf .
COPY health.html .

# Stage 2: Create the final web server image
FROM nginx:alpine

COPY --from=builder /app/index.html /usr/share/nginx/html/index.html
COPY --from=builder /app/health.html /usr/share/nginx/html/health.html
COPY --from=builder /app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s \
  CMD wget -q -O /dev/null http://127.0.0.1/health || exit 1