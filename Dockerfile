FROM jenkinsci/jenkins:2.136
MAINTAINER Mamadou Saliou BAH

ENV DEBIAN_FRONTEND=noninteractive

USER root

# docker group id, on AWS ECS the default gid is 497
ARG DOCKER_GID=497

RUN groupadd -g ${DOCKER_GID:-497} docker

ARG DOCKER_ENGINE=1.10.2
ARG DOCKER_COMPOSE=1.6.2

RUN apt-get update -y && \
    apt-get install apt-transport-https curl python-dev python-setuptools gcc make libssl-dev -y && \
    easy_install pip

# Install Docker Engine
#RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
#    echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list && \
#    apt-get update -y && \
#    apt-get purge lxc-docker* -y && \
 #   apt-get install docker-engine=${DOCKER_ENGINE:-1.10.2}-0~trusty -y && \
RUN 	apt-get update \
   	&& apt-get install -y curl ca-certificates \
  	&& curl -s https://get.docker.com/ | sed 's/docker-engine/docker-engine=£{DOCKER_ENGINE/-1.10.2}/' | sh \  
  	&& usermod -aG docker jenkins \
    	&& usermod -aG users jenkins

# Install Docker Compose
RUN pip install docker-compose==${DOCKER_COMPOSE:-1.6.2} && \
    pip install ansible boto boto3

# Change to jenkins user
USER jenkins

# Add Jenkins plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
