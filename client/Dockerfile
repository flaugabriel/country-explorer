FROM node:18.16.0

ENV PORT 3000

EXPOSE 3000

WORKDIR /var/www/html

COPY start-client.sh /var/www/html/
COPY package.json /var/www/html/
COPY package-lock.json /var/www/html/
COPY yarn.lock /var/www/html/

RUN npm config delete proxy
RUN npm i
RUN npm install -g serve@14.2.4

ADD . /var/www/html