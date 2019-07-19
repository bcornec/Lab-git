#!/bin/bash
# Modify openssl.cnf to activate extensions (SAN)
sed -i -e 's/# req_extensions = v3_req/req_extensions = v3_req/' /etc/pki/tls/openssl.cnf
sed -i -e '/^keyUsage = nonRepudiation, digitalSignature, keyEncipherment/ a subjectAltName = @alt_names' /etc/pki/tls/openssl.cnf
cat << EOF >>/etc/pki/tls/openssl.cnf
[alt_names]
DNS.1 = $PUBFQDN
EOF

# Generate CA key + cert
umask 277 && openssl genrsa 2048 > ca/ca.key
umask 007 && openssl req -new -x509 -days 365 -subj "/C=FR/ST=Isere/L=Grenoble/O=CGI/CN=ca" -key ca/ca.key > ca/ca.crt
# Generate server (registry) key + csr
umask 002 && openssl genrsa 2048 > srv/repo.key
umask 002 && openssl req -new \
   	-subj "/C=FR/ST=Isere/L=Grenoble/O=CGI/CN=$PUBFQDN" \
   	-key srv/repo.key \
	> srv/repo.csr
# Sign the csr with the CA
umask 002 && openssl x509 -req -in srv/repo.csr \
   	-out srv/repo.crt \
   	-CA ca/ca.crt \
   	-CAkey ca/ca.key \
   	-CAcreateserial \
   	-CAserial ca/ca.srl \
    -days 365 \
	-extensions v3_req -extfile /etc/pki/tls/openssl.cnf
# Put the CA certificate on the web
cp /home/pki/ca/ca.crt /var/www/html
chown pki:pki /var/www/html/ca.crt && chmod 644 /var/www/html/ca.crt
httpd -DFOREGROUND
