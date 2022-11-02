FROM balenalib/raspberry-pi:buster
RUN apt update
RUN apt install -y openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables iptables-dev pkg-config nmap tcpdump apache2 wget curl
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]