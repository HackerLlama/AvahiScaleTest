FROM ubuntu
MAINTAINER Hacker Llama <hackerllama@bluellama.com>
RUN apt-get -qqy update
RUN apt-get -qqy install wget build-essential intltool pkg-config libglib2.0-dev  libexpat1-dev libgdbm-dev libdaemon-dev doxygen graphviz xmltoman git 
RUN mkdir /AvahiLite
WORKDIR /AvahiLite
COPY avahi-0.6.31.tar.gz /AvahiLite/avahi-0.6.31.tar.gz
RUN tar xzvf avahi-0.6.31.tar.gz
WORKDIR avahi-0.6.31
RUN ./configure --silent --with-distro=debian --sysconfdir=/etc --localstatedir=/var --disable-qt3 --disable-qt4 --disable-gtk --disable-gtk3 --disable-dbus --disable-python --disable-pygtk --disable-python-dbus --disable-mono --disable-monodoc
RUN make --silent
RUN make --silent install
RUN ldconfig
RUN addgroup --system avahi
RUN adduser --system --no-create-home --ingroup avahi avahi
RUN mkdir /nss-mdns
WORKDIR /nss-mdns
RUN apt-get -qqy download libnss-mdns
RUN ls
RUN dpkg --force-all -i libnss-mdns_0.10-6_amd64.deb
WORKDIR /AvahiLite
COPY avahi-daemon.conf.inContainer /etc/avahi/
RUN mv /etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf.orig
RUN mv /etc/avahi/avahi-daemon.conf.inContainer /etc/avahi/avahi-daemon.conf
COPY pipework /usr/bin/pipework
COPY bootAvahiContainer /AvahiLite/bootAvahiContainer
RUN chmod +x /AvahiLite/bootAvahiContainer
CMD ["/AvahiLite/bootAvahiContainer", ""]




