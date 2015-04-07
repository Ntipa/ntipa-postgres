FROM ubuntu:trusty
MAINTAINER Tindaro Tornabene <tindaro.tornabene@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
 
RUN apt-get -y update
RUN apt-get -y install wget
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list

RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list
RUN apt-get -y update


RUN apt-get install -yqq inetutils-ping net-tools 



RUN locale-gen --no-purge it_IT.UTF-8
ENV LC_ALL it_IT.UTF-8
RUN update-locale LANG=it_IT.UTF-8

RUN apt-get -y install postgresql-9.4 postgresql-contrib-9.4 postgresql-9.4-postgis-2.1 postgis postgresql-client-9.4
RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN service postgresql start && \
 /bin/su postgres -c "createuser -d -s -r -l ntipa"  && \
 /bin/su postgres -c "psql postgres -c \"ALTER USER ntipa WITH ENCRYPTED PASSWORD 'ntipa'\" "  && \
 /bin/su postgres -c "createdb -O ntipa ntipa-manager" && \
 /bin/su postgres -c "createdb -O ntipa ntipa-protocollo" && \
 /bin/su postgres -c "createdb -O ntipa ntipa-manager-dev" && \
 /bin/su postgres -c "createdb -O ntipa ntipa-protocollo-dev" && \
 /bin/su postgres -c "createdb -O ntipa ntipa-jbilling" && \
 /bin/su postgres -c "createdb -O ntipa ntipa-jbilling-dev" && \ 
 /bin/su postgres -c "createdb -O ntipa ntipa-drupal" && \ 
 /bin/su postgres -c "createdb -O ntipa ntipa-drupal-dev"
 
RUN service postgresql stop
RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.4/main/postgresql.conf
RUN echo "port = 5432" >> /etc/postgresql/9.4/main/postgresql.conf



EXPOSE 5432

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]
 