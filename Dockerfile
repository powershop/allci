FROM ubuntu:16.04

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse" > /etc/apt/sources.list && \
	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" >> /etc/apt/sources.list && \
	DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install ruby2.3 ruby2.3-dev libmysqlclient-dev build-essential tzdata && \
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
CMD ./cmd.sh
