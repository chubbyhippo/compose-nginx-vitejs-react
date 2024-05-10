# Start from the Node.js LTS image
FROM node:22 AS build-stage

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY react-app/package*.json ./

# Install any dependencies
RUN npm install

# Copy local files to the app directory
COPY react-app/. .

# Build the app for production
RUN npm run build

# Production stage
FROM nginx:stable-alpine AS production-stage

# Copy built app to nginx serve directory
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 80 to outside world
EXPOSE 80

# Start nginx with global directives and daemon off
CMD ["nginx", "-g", "daemon off;"]