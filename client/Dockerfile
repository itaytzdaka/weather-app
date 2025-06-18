# Dockerfile - Client

# Use Node.js to build React app
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json .
RUN npm ci --omit=dev

COPY . .

# Build React
RUN npm run build

# Serve with Nginx
FROM nginx:1.25-alpine

COPY --from=builder /app/build /usr/share/nginx/html

# Optional: Add custom Nginx config (e.g., for SPA routing)
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]