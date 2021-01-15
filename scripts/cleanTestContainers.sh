#!/bin/sh

rm -rf ./integrationTest

if [[ "$(docker images -q devapp:latest 2> /dev/null)" != "" ]]; then
  docker rmi devapp:latest
fi

if [[ "$(docker images -q prodapp:latest 2> /dev/null)" != "" ]]; then
  docker rmi prodapp:latest
fi
