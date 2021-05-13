FROM golang:1.15-alpine as build

LABEL maintainer="Seungho Jeong<platoon07@khu.ac.kr>"

RUN apk add --update \
    wget 

RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync \
    build-base \
    libc6-compat \
    npm && \
    npm install -D autoprefixer postcss-cli

ARG HUGO_VERSION="0.82.0"

RUN wget --quiet "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    mv hugo /usr/bin

COPY ./ /site
WORKDIR /site
RUN hugo --minify

FROM nginx:alpine
COPY --from=build /site/public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html





