#!/bin/sh
if [ "$RAKE_TASKS" = "" ]; then
	rm -f /app/tmp/pids/server.pid
	bundle exec rails server
else
	bundle exec rake $RAKE_TASKS --trace
fi
