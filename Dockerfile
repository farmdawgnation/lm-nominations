FROM node:12.5.0-stretch

ADD . /opt/lm-nominations

WORKDIR /opt/lm-nominations

RUN rm -rf node_modules .git && npm install

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64

RUN chmod +x /usr/local/bin/dumb-init

USER nobody

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["node", "app.js"]
