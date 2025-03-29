#!/bin/sh

# Replace env vars in nginx.template.conf and save as nginx.conf
envsubst '${SERVER} ${PORT}' < /etc/nginx/nginx.template.conf > /etc/nginx/conf.d/default.conf

# Start nginx
exec nginx -g 'daemon off;'
