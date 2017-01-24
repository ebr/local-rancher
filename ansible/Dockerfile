FROM library/ubuntu:16.04
MAINTAINER Eugene Brodsky <ebr@users.noreply.github.com>

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y update && \
  apt-get -y install \
    ansible \
    curl \
    git \
    python \
    python-pip

RUN pip install ansible

RUN mkdir ansible
WORKDIR '/ansible'

ENTRYPOINT ["ansible"]