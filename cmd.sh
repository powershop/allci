#!/bin/sh
if [ "$RAKE_TASKS" = "" ]; then
	bundle exec rails server
else
	bundle exec rake $RAKE_TASKS --trace
fi
