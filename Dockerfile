FROM ruby:2.7

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y postgresql-client

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
# Suppress ruby 2.7 warnings
# ENV RUBYOPT "-W:no-deprecated -W:no-experimental"

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN gem install bundler -v 1.17.3
RUN bundle install --deployment --without development test

COPY . /usr/src/app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-e", "production"]
