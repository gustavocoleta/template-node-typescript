FROM node:22.20.0-alpine

ARG GITHUB_TOKEN
ARG NODE_ENV=development

ENV NODE_ENV=${NODE_ENV}

ENV NODE_OPTIONS=--max-old-space-size=8192

RUN apk --update add --no-cache bash

RUN mkdir /etc/localtime

ENV TZ=America/Sao_Paulo

RUN apk update

RUN echo "America/Sao_Paulo" >  /etc/timezone

RUN echo 'export LC_ALL=pt_BR.UTF-8' >> /etc/profile.d/locale.sh && \
  sed -i 's|LANG=C.UTF-8|LANG=pt_BR.UTF-8|' /etc/profile.d/locale.sh

ENV LANG=pt_BR.utf8
ENV LC_ALL=pt_BR.utf8
ENV LANGUAGE=pt_BR.utf8

RUN npm i -g npm

USER root

WORKDIR /home/node/app

COPY . .

RUN chown -R node:node /home/node/app

USER node

RUN if [[ ! -z "$GITHUB_TOKEN" ]] ; then touch .npmrc &&  echo "@vrsoftbr:registry=https://npm.pkg.github.com" >> .npmrc && echo "//npm.pkg.github.com/:_authToken=$GITHUB_TOKEN" >>".npmrc" ; fi

RUN if [[ "$NODE_ENV" == test ]] ; then npm ci --legacy-peer-deps ; fi
