FROM debian:9
MAINTAINER bruno@flossita.org
RUN apt-get update
RUN apt-get install -y wget make patch sudo dh-make apt-file lintian openssh-server
RUN useradd -m -s /bin/bash -d /home/pkg -p '$6$edXqzrSb$YNr2eI9Jl/vxbWwTR8HEYksPo6YQjx4dHwOMfNTPjLzA5UfdTNz32flhfleyBlhnEqrSoeBrXGanOHlDykN2D1' pkg
RUN echo "pkg   ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
COPY ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
COPY ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
COPY ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
COPY ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
RUN chmod 600 /etc/ssh/ssh_host_*
RUN mkdir /run/sshd
#RUN chown -R pkg /home/pkg
WORKDIR /home/pkg
USER pkg
ENTRYPOINT sudo /usr/sbin/sshd -D
