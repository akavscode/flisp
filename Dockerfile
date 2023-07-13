FROM node:latest
EXPOSE 3000
WORKDIR /app
COPY files/* /app/

RUN apt-get update -y &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    chmod +x web.js

ENTRYPOINT [ "node", "server.js" ]