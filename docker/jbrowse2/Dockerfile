FROM node:20-bookworm-slim

RUN npm install -g http-server @jbrowse/cli && jbrowse --version

WORKDIR /var/www/html/jbrowse2

RUN jbrowse create .

CMD ["http-server", ".", "--cors", "-d", "false"]

EXPOSE 8080
