FROM node:18-alpine
LABEL org.opencontainers.image.source="https://github.com/islamdiaa/harbr"
# Install packages, copy data, build project
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
RUN npm prune --production
# Add Tini
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
# Start the docker version, expose port 9000
CMD ["npm", "run", "docker"]
EXPOSE 9000
