FROM fedora:30
RUN dnf install -y httpd
RUN useradd pki
RUN chmod 755 /home/pki
RUN rm /etc/httpd/conf.d/welcome.conf
EXPOSE 80
USER pki
WORKDIR /home/pki
RUN mkdir ca srv
USER root
COPY ./run.sh /home/pki
RUN chmod +x /home/pki/run.sh
CMD ["./run.sh"]
