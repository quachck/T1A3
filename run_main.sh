#!/bin/bash

gem install bundler
bundle install
chmod 755 run_main.sh
clear
ruby main.rb $1