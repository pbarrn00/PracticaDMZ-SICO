FROM balenalib/raspberry-pi:buster
RUN apt update
RUN apt install -y openssh-server net-tools iputils-ping traceroute nano iproute2 iptables iptables-dev pkg-config nmap tcpdump apache2 wget curl libpam-google-authenticator fail2ban rsyslog
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd

# Creamos un usuario no root
RUN useradd -m -d /home/user1 -s /bin/bash user1
RUN echo 'user1:user1' |chpasswd

WORKDIR /root
RUN mkdir /root/.ssh
RUN mkdir /home/user1/.ssh

# Hardening OpenSSH Server (Optional)
COPY ./sshd_config /etc/ssh/sshd_config
COPY ./id_rsa.pub .
RUN cat id_rsa.pub > /root/.ssh/authorized_keys
RUN cat id_rsa.pub > /home/user1/.ssh/authorized_keys
RUN chmod 640 /root/.ssh/authorized_keys
COPY ./banner /etc/ssh/
COPY ./sshd /etc/pam.d/
# Fail2ban
COPY ./jail.conf /etc/fail2ban/

RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]

RUN service fail2ban start

# HTTPS Config (Optional)
COPY ./index.html /var/www/html/
# Preguntar FORBIDEN 403 cuando meto el index.html personalizado, A DELA NO LE PASA
RUN chmod 644 /var/www/html/index.html
RUN mkdir /etc/apache2/certificate
RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/apache2/certificate/apache-certificate.crt -keyout /etc/apache2/certificate/apache.key -subj "/C=ES/ST=CYL/L=Leon/O=ULE/CN=pbarrn00"
COPY ./000-default.conf /etc/apache2/sites-available/
# Solucionar error de apache2: Invalid command 'SSLProxyEngine', perhaps misspelled or defined by a module not included in the server configuration
RUN a2enmod ssl 
RUN service apache2 restart


