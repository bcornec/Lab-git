FROM centos:7
RUN yum install -y wget make patch rpm-build diffutils sudo rpmdevtools rpmlint openssh-server
# Used: perl -e 'use Crypt::PasswdMD5; print crypt("Pkg@TSS19", "\$6\$rl1WNGdr\$"),"\n"' to create the Password
RUN useradd -p '$6$edXqzrSb$YNr2eI9Jl/vxbWwTR8HEYksPo6YQjx4dHwOMfNTPjLzA5UfdTNz32flhfleyBlhnEqrSoeBrXGanOHlDykN2D1' pkg
RUN echo "pkg   ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
COPY ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
COPY ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
COPY ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
COPY ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
RUN chmod 600 /etc/ssh/ssh_host_*
WORKDIR /home/pkg
USER pkg
ENTRYPOINT sudo /usr/sbin/sshd -D
