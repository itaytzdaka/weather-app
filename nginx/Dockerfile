FROM nginx:1.25-alpine

# Optional: Add custom Nginx config (e.g., for SPA routing)
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]