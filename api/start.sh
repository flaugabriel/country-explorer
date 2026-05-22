#!/bin/bash
gem install bundle
bundle check || bundle install
rm -f tmp/pids/server.pid
bundle exec rails db:create db:migrate
bundle exec rails s -p 3030 -b 0.0.0.0