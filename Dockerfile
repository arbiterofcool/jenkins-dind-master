FROM java:8
MAINTAINER Sean Chatman <xpointsh@gmail.com>

### Getting apt lists
RUN echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list
RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -

RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

USER root

# Install basics.
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
    iptables \
    ca-certificates \
    lxc \
    apt-transport-https \
    jenkins \
    lxc-docker

# Install Docker from Docker Inc. repositories.
#RUN apt-get update -qq
#RUN apt-get install -qqy lxc-docker

# Install the magic wrapper.
ADD ./wrapdocker /etc/my_init.d/wrapdocker
RUN chmod +x /etc/my_init.d/wrapdocker