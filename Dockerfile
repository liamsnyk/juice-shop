FROM node:16  as installer
COPY . /juice-shop
WORKDIR /juice-shop
RUN npm i -g typescript ts-node
RUN npm install --production --unsafe-perm 
RUN npm dedupe
RUN rm -rf frontend/node_modules

FROM node:14.1.0
WORKDIR /juice-shop
RUN apt-get update  && apt-get install sa-exim -y && apt-get install iputils-ping -y  && apt-get install nmap -y 
RUN npm install -g n 16
RUN addgroup --system --gid 1001 juicer && \
    adduser juicer --system --uid 1001 --ingroup juicer
COPY --from=installer --chown=juicer /juice-shop .
RUN mkdir logs && \
    chown -R juicer logs && \
    chgrp -R 0 ftp/ frontend/dist/ logs/ data/ i18n/ && \
    chmod -R g=u ftp/ frontend/dist/ logs/ data/ i18n/
USER 1001
EXPOSE 3000
CMD ["npm", "start"]
