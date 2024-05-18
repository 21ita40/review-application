# Use a Node.js base image for building frontend
FROM node:14-alpine as frontend-build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# Use a Node.js base image for backend
FROM node:14-alpine as backend
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]

# Use a minimal Nginx image to serve frontend
FROM nginx:alpine
COPY --from=frontend-build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
