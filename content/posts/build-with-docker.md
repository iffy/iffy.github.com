Title: Build static assets with Docker
Date: 2015-03-26
Tags: personal, programming
Template: article.longform

## tl;dr ##

Consider making the "Hello, world!" instruction to build your project/docs/tests a single, simple `docker run`.  That way, your users don't have to mess around trying to get an environment working.  Host the base image on Docker hub and you're done!

## Building static assets ##

[Docker](https://www.docker.com/) is a neat tool.  Today I made use of it to build all my web app's static assets (SASS to CSS, JS concatenation, minification, etc...).  I got tired of manually installing Ruby, NodeJS, and Python packages on the various machines I use (OS X and Ubuntu).  So I punted to Docker.

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

    docker run -v $(PWD):/build static-builder /bin/bash -l build.sh

(`build.sh` is a custom build script for this particular project.  You could also use Grunt/gulp/whatever).

## Collaboration win ##

I did this for a personal project on which the only collaborators are myself and myself on a different computer.  But such a setup would be great on projects with lots of collaborators.

Thanks, Docker!
