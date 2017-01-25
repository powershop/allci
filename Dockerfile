FROM ubuntu:16.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt-get -y install ruby2.3 ruby2.3-dev libmysqlclient-dev build-essential && \
	apt-get clean -y && \
	rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN gem install bundler

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --deployment --path /gems

ADD . /app
WORKDIR /app
RUN bundle install --deployment --path /gems

ENV MYSQL_SERVER=db
CMD ["bundle", "exec", "rake", "wait_for_database", "db:create", "db:migrate", "default"]
