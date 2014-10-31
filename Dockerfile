FROM kiyohara/docker-supervisor

MAINTAINER Tomokazu Kiyohara <tomokazu.kiyohara@gmail.com>

## supervisord
ADD etc/supervisor/conf.d/sshd.conf /etc/supervisor/conf.d/sshd.conf

## sshd
RUN apt-get -y install openssh-server
RUN mkdir -p /var/log/sshd
RUN mkdir -p /var/run/sshd

RUN useradd docker
RUN mkdir -p /home/docker/.ssh;
RUN chown docker /home/docker/.ssh
RUN chmod 700 /home/docker/.ssh
ADD ./_ssh/authorized_keys /home/docker/.ssh/authorized_keys
RUN chown docker /home/docker/.ssh/authorized_keys
RUN chmod 600 /home/docker/.ssh/authorized_keys
RUN chsh -s /bin/bash docker

RUN gpasswd -a docker adm
RUN gpasswd -a docker sudo
RUN mkdir -p /etc/sudoers.d/
ADD etc/sudoers.d/docker /etc/sudoers.d/docker
RUN chmod 400 /etc/sudoers.d/docker

EXPOSE 22

CMD [ "/usr/bin/supervisord" ]
