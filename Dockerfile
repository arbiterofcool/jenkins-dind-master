FROM jenkins:latest
MAINTAINER Sean Chatman <xpointsh@gmail.com>

### Installing Docker in Docker ###

USER root

# Install basics.
RUN apt-get update -qq
RUN apt-get install -qqy \
    iptables \
    ca-certificates \
    lxc \
    apt-transport-https

# Install Docker from Docker Inc. repositories.
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get update -qq
RUN apt-get install -qqy lxc-docker

# Install the magic wrapper.
ADD ./wrapdocker /etc/my_init.d/wrapdocker
RUN chmod +x /etc/my_init.d/wrapdocker

USER jenkins

# Add jobs in children
ONBUILD ADD ./jobs /var/jenkins_home/jobs

# Add plugins in children
ONBUILD ADD ./installplugins /etc/my_init.d/installplugins
ONBUILD RUN chmod +x /etc/my_init.d/installplugins

