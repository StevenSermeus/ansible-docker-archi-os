FROM --platform=linux/amd64 nginx:1.21.3-alpine

ENV PORT 8080
ENV PROXY_PASS http://quark:8080
ENV SERVER_NAME localhost
EXPOSE $PORT

# Using envsubst to replace environment variables in the nginx.conf file
CMD ["/bin/sh", "-c", "envsubst < /tmp/nginx.conf > etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"]