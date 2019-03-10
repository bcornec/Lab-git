FROM centos:7
RUN yum install -y wget make patch rpm-build diffutils sudo rpmdevtools rpmlint openssh-server python3
# Used: perl -e 'use Crypt::PasswdMD5; print crypt("Redfish@TSS19", "\$6\$rl1WNGdr\$"),"\n"' to create the Password
RUN useradd -p '$6$rl1WNGdr$qHyKDW/prwoj5qQckWh13UH3uE9Sp7w43jPzUI9mEV6Y1gZ3MbDDMUX/1sP7ZRnItnGgBEklmsD8vAKgMszkY.' redfish
RUN echo "redfish   ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
COPY ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
COPY ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
COPY ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
COPY ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
RUN chmod 600 /etc/ssh/ssh_host_*
WORKDIR /home/redfish
USER redfish
ENTRYPOINT sudo /usr/sbin/sshd -D #-d -d -d
