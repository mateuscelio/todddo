#!/bin/bash

bundle install
bundle exec rails db:setup
bundle exec rails s -b 0.0.0.0
