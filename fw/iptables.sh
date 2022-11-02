#!/bin/bash

# Activación del bit de forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Cambiar la política por defecto de las cadenas INPUT y FORWARD para que descarten los paquetes.
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Cambiar la política de OUTPUT para que permita pasar todos los paquetes.
iptables -P OUTPUT ACCEPT

# Permitir el tráfico entrante a través de la interfaz de loopback
iptables -A INPUT -i lo -j ACCEPT

# Permitir el tráfico entrante correspondiente a cualquier conexión previamente establecida.
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir consultas entrantes de tipo ICMP ECHO REQUEST.
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Permitir el tráfico de conexiones establecidas y relacionadas para TCP, UDP y ICMP.
# Reglas que permiten el tráfico de cualquier interfaz
# 
# iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A FORWARD -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A FORWARD -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir el tráfico de conexiones establecidas y relacionadas para TCP, UDP y ICMP.
# Comprobar que el tráfico FORWARD sale por las interfaces de red correctas.
iptables -A FORWARD -p tcp -i eth2 -o eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p udp -i eth2 -o eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p icmp -i eth2 -o eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A FORWARD -p tcp -i eth2 -o eth1 -s 10.5.2.0/24 -d 10.5.0.0/24 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p udp -i eth2 -o eth1 -s 10.5.2.0/24 -d 10.5.0.0/24 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p icmp -i eth2 -o eth1 -s 10.5.2.0/24 -d 10.5.0.0/24 -m state --state NEW -j ACCEPT
