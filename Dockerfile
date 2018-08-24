From ubuntu:trusty
MAINTAINER Elliott Ye

#####Postfix Section#####
# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update

# Start editing
# Install package here for cache
RUN apt-get -y install supervisor postfix sasl2-bin opendkim opendkim-tools

# Add files
ADD assets/install.sh /opt/install.sh

#####Bareos Section#####
RUN apt-get update -y
RUN apt-get install -y wget

ENV DIST=xUbuntu_14.04
ENV RELEASE=release/17.2/

ENV URL=http://download.bareos.org/bareos/$RELEASE/$DIST

RUN bash -c 'echo "deb http://download.bareos.org/bareos/release/17.2/xUbuntu_14.04/ /" > /etc/apt/sources.list.d/bareos.list'
RUN bash -c 'wget -q http://download.bareos.org/bareos/release/15.2/xUbuntu_14.04/Release.key -O- | apt-key add -'

RUN apt-get update
RUN apt-get install -y bareos
RUN apt-get install -y bareos-database-mysql
RUN apt-get install -y mysql-server

ADD entrypoint.sh /entrypoint.sh

COPY entrypoint.sh /etc/init.d

EXPOSE 9101
EXPOSE 25

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR "/etc/init.d"

# Run
CMD /opt/install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
