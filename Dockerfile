FROM centos:centos7
MAINTAINER Brian Kocoloski <brian.kocoloski@wustl.edu>

ENV USER cc
ENV HOME /home/${USER}
ENV SSH_DIR ${HOME}/.ssh

RUN yum -y update && \
    yum -y install openssh-server openssh-clients \
           openmpi openmpi-devel \
           chrpath which python2 sudo && \
    yum clean all && rm -rf /var/cache/yum


# sshd setup
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

# User creation
RUN useradd ${USER}
RUN usermod -aG wheel ${USER}
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# ssh key for openmpi
COPY ssh-keys/id_rsa.vb ${HOME}/.ssh/id_rsa
COPY ssh-keys/id_rsa.vb.pub ${HOME}/.ssh/authorized_keys
COPY ssh-keys/config ${HOME}/.ssh/config
RUN chmod -R 700 ${SSH_DIR} && chmod -R 600 ${SSH_DIR}/*

# Disable core dumps
RUN echo "* hard core 0" >> /etc/security/limits.conf

# Copy varbench stuff 
COPY files/bashrc ${HOME}/.bashrc
COPY files/bash_profile ${HOME}/.bash_profile
COPY files/container-scripts ${HOME}/scripts
COPY generated-files/files ${HOME}
RUN chrpath ${HOME}/varbench -r ${HOME}:/usr/lib64/openmpi/lib
RUN chown -R ${USER}:${USER} ${HOME}

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
