# Stage 1 - Building the App
FROM node:21 AS build
WORKDIR /app
COPY react-app/package*.json ./
COPY react-app/. .
RUN npm install
RUN npm run build

# Stage 2 - Serving the App via Nginx
FROM nginx:alpine
# Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*
# Copy built app to Nginx server directory
COPY --from=build /app/dist /usr/share/nginx/html
# Copy the Nginx configuration file
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]