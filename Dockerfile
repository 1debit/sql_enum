FROM ruby:3.0

WORKDIR /usr/src/app

RUN mkdir -p lib/sql_enum gemfiles
COPY lib/sql_enum/version.rb  ./lib/sql_enum/
COPY gemfiles/*.gemfile gemfiles/
COPY sql_enum.gemspec Gemfile Gemfile.lock Appraisals ./
RUN bundle install && \
    bundle exec appraisal install
