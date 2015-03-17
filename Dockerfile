### install debian ###
FROM debian:latest
MAINTAINER u.seltmann@gmail.com
EXPOSE 80 443 3306
VOLUME ["/var/lib/mysql", "/var/run/mysqld", "/app", "/var/lib/xdebug"]
ENTRYPOINT ["/docker/init"]
CMD ["run"]
ENV DEBIAN_FRONTEND noninteractive
# adding dot-deb repository
RUN apt-get update \
 && apt-get -y dist-upgrade \
 && apt-get install -y wget less vim supervisor nullmailer

RUN echo "deb http://packages.dotdeb.org wheezy all" >/etc/apt/sources.list.d/dotdeb.list \
 && wget -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add - \
 && apt-get update \
 && apt-get install -y openssl ca-certificates apache2-mpm-worker apache2-suexec libapache2-mod-fcgid \
        php5-cgi php5-cli php-pear php5-curl php5-gd php5-intl php5-ldap php5-mcrypt php5-mysqlnd php5-readline php5-sqlite php5-xcache php5-xdebug php5-xsl php5-dev \
        make mysql-client mysql-server unzip
COPY assets/build /docker/build
RUN chmod 755 /docker/build/init \
 && /docker/build/init

COPY assets/setup /docker/setup
COPY assets/run /docker/run
COPY assets/init /docker/init
RUN chmod 755 /docker/init /docker/run/*
