FROM golang:1.15-alpine as build

LABEL maintainer="Seungho Jeong <platoon07@khu.ac.kr>"

RUN apk add --update \
    wget 



COPY package*.json ./

RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync \
    build-base \
    libc6-compat \
    npm && \
    npm install --no-optional -D autoprefixer postcss-cli 

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

EXPOSE 8080
CMD ["/bin/sh", "-c", "sed -i 's/listen  .*/listen 8080;/g' /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"]
WORKDIR /usr/share/nginx/html
