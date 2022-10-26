#!/bin/bash

# Activación del bit de forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Cambiar la pol ́ıtica por defecto de las cadenas INPUT y FORWARD para que descarten los paquetes.
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Cambiar la pol ́ıtica de OUTPUT para que permita pasar todos los paquetes.
iptables -P OUTPUT ACCEPT

# Permitir el tráfico entrante a través de la interfaz de loopback
iptables -A INPUT -i lo -j ACCEPT

# Permitir el tráfico entrante correspondiente a cualquier conexión previamente establecida.
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir consultas entrantes de tipo ICMP ECHO REQUEST.
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

