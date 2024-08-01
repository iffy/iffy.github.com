# From https://github.com/github/pages-gem/blob/master/Dockerfile.alpine
FROM ruby:3.3-alpine

RUN apk update && apk add --no-cache \
  git

RUN git clone https://github.com/github/pages-gem.git /src/gh/pages-gem

# one step to exclude .build_deps from docker cache
RUN apk update && apk add --no-cache --virtual .build_deps \
    make \
    build-base && \
  bundle config local.github-pages /src/gh/pages-gem && \
  bundle install --gemfile=/src/gh/pages-gem/Gemfile && \
  apk del .build_deps

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ADD Gemfile .
RUN bundle install

WORKDIR /src/site

CMD ["jekyll", "serve", "-H", "0.0.0.0", "-P", "4000"]
