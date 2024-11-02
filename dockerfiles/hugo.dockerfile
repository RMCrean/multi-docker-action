# Use alpine Linux, download desired version of HUGO and build html files
FROM alpine:3.19.1 AS build
RUN apk add --no-cache wget=1.21.4-r0


ARG JBROWSE_VERSION="v2.15.4"
ARG HUGO_VERSION="0.123.7"

# GH actions triggered runs can overwrite these values
ARG HUGO_PORTAL_VERSION=""
ARG HUGO_GIT_BRANCH=""
ARG HUGO_GIT_SHA=""

RUN apk add --no-cache wget

RUN wget --quiet "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    mv hugo /usr/bin && \
    chmod 755 /usr/bin/hugo

WORKDIR /src
COPY ./hugo/ /src


# pass the environment variables to the build
RUN mkdir /target && \
    export HUGO_PORTAL_VERSION=${HUGO_PORTAL_VERSION} && \
    export HUGO_GIT_BRANCH=${HUGO_GIT_BRANCH} && \
    export HUGO_GIT_SHA=${HUGO_GIT_SHA} && \
    export HUGO_JBROWSE_VERSION=${JBROWSE_VERSION} && \
    hugo -d /target --minify --gc

# Serve the generated html using nginx
FROM nginxinc/nginx-unprivileged:alpine
RUN sed -i '3 a\    absolute_redirect off;' /etc/nginx/conf.d/default.conf && \
    sed -i 's/#error_page  404/error_page  404/' /etc/nginx/conf.d/default.conf
COPY --from=build /target /usr/share/nginx/html

EXPOSE 8080
