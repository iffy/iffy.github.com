Title: Build static assets with Docker
Date: 2015-03-26
Tags: personal, programming
Template: article.longform

[Docker](https://www.docker.com/) is a neat tool.  Today I made use of it to build all my static assets (JS/SASS/minification, etc...).  I got tired of manually installing Ruby, NodeJS, and Python packages on the various machines I use (OS X and Ubuntu).  So I punted to Docker.

Here's my Dockerfile:


```
FROM ubuntu:14.04
MAINTAINER matt

RUN apt-get update -y
RUN apt-get install -y build-essential
RUN apt-get install -y curl
RUN apt-get install -y ruby-full
RUN apt-get install -y python-dev
RUN apt-get install -y python-pip
RUN apt-get install -y libffi-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y git

# Install node/npm/bower
RUN curl -sL https://deb.nodesource.com/setup | sudo bash - && apt-get install -y nodejs
RUN npm install -g bower

# Install sass
RUN gem install sass

# Install python stuff
WORKDIR /tmp
RUN pip install --upgrade pip
COPY requirements.build.txt requirements.build.txt
RUN pip install -r requirements.build.txt

# npm
RUN mkdir /common
WORKDIR /common
COPY package.json package.json
RUN npm install
RUN echo 'export PATH=/common/node_modules/.bin:${PATH}' > /etc/profile.d/common_node.sh

RUN mkdir /build
WORKDIR /build
```

I create a build-capable container on any machine with Docker installed:

    docker build -t static-builder -f staticbuilder.Dockerfile .

Then I mount the project directory and build/install all the assets:

    docker run -v $(PWD):/build pb-static-builder /bin/bash -l build.sh

(`build.sh` is a custom script for building all the things.  You could also use grunt/gulp/whatever).

I could even host the built image somewhere so that I didn't even have to do the build step on each machine -- just download the image and go!

Thanks, Docker!