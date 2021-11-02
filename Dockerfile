FROM alpine:3.14

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

RUN apk upgrade --update

RUN apk add \
    texlive \
    texlive-full \
    texlive-xetex

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN apk add \
    pandoc@edge \
    plantuml@edge \
    py3-pip \
    yarn

RUN apk add wget \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs

RUN adduser pandoc -D -u 1000

RUN yarn add mermaid mermaid.cli
RUN yarn add puppeteer@10.2.0

ADD ./puppeteer-config.json /puppeteer-config.json

ADD ./pandoc_filter.py /usr/bin/mermaid-filter
RUN chmod u=rwx,go=rx /usr/bin/mermaid-filter

RUN pip install panflute

RUN ln -sf /node_modules/.bin/mmdc /usr/bin/mmdc

USER pandoc

WORKDIR /home/pandoc/