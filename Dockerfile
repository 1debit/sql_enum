FROM ruby:3.0

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

# Bundler caching
RUN mkdir -p lib/sql_enum
COPY lib/sql_enum/version.rb  ./lib/sql_enum/
COPY sql_enum.gemspec Gemfile Gemfile.lock ./
RUN bundle install
