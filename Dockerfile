FROM node:20 AS build-stage

WORKDIR /app

COPY react-app/package*.json ./

RUN npm ci

COPY react-app/. .

RUN npm run build

FROM nginx:stable-alpine AS production-stage

EXPOSE 80

COPY --from=build-stage /app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]