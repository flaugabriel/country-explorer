FROM ruby:3.0.2

ENV PORT 3030
EXPOSE 3030
EXPOSE 1080
ENV APP_HOME /api

RUN apt-get update -qq
RUN apt install build-essential -y

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock

RUN gem install bundle
RUN bundle install
RUN gem install thin -v 1.5.1 -- --with-cflags="-Wno-error=implicit-function-declaration"

COPY lib/ $APP_HOME/vendor/

ADD Gemfile* $APP_HOME/

ADD . $APP_HOME
