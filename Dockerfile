FROM ruby:3.3-alpine

# Install dependencies
RUN apk update && apk add --no-cache \
    git \
    build-base \
    make

# Set environment variables for locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Copy Gemfile and Gemfile.lock (if it exists)
COPY Gemfile* /src/site/

# Set working directory
WORKDIR /src/site

# Install gems
RUN bundle install

# Expose port for Jekyll server
EXPOSE 4000

# Start Jekyll server
CMD ["bundle", "exec", "jekyll", "serve", "-H", "0.0.0.0", "-P", "4000"]
