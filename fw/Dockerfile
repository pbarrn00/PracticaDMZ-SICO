FROM balenalib/raspberry-pi:buster
RUN apt-get update
RUN apt-get install -y openssh-server net-tools iputils-ping traceroute vim iptables iptables-dev pkg-config
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
COPY ./start.sh .
RUN chmod +x start.sh
# IP Tables Script
COPY ./iptables.sh .
RUN chmod +x iptables.sh
CMD ["./start.sh && ./iptables.sh"]