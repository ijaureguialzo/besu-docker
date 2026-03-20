ARG NODE_VERSION=lts-trixie

FROM alpine/git:latest AS cloner
WORKDIR /tmp
RUN git clone https://github.com/goerli/ethstats-server

FROM node:${NODE_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apt update &&  \
    apt install -y bash nano

RUN npm install -g grunt-cli

WORKDIR /ethstats-server

COPY --from=cloner /tmp/ethstats-server /ethstats-server
RUN npm install

RUN grunt poa
