#!/bin/bash

# install dependencies and run main program
gem install bundler
bundle install
clear
ruby main.rb $1