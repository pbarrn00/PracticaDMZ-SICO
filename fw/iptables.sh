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
iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT

# Todo el tráfoco que entre en fw a través de la interfaz con la red interna, con protocolo TCP, UDP o
# ICMP, con dirección IP origen en el rango 10.5.20.0/24, y que vaya a salir a través de la interfaz con la
# red externa.
iptables -A FORWARD -p tcp -i eth2 -o eth1 -s 10.5.2.0/24 -d 10.5.0.0/24 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p udp -i eth2 -o eth1 -s 10.5.2.0/24 -d 10.5.0.0/24 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p icmp -i eth2 -o eth1 -s 10.5.2.0/24 -d 10.5.0.0/24 -m state --state NEW -j ACCEPT

# Permitir tráfico ICMP desde internal a dmz (no lo pide en la práctica , duda Raul)
iptables -A FORWARD -p icmp -i eth2 -o eth0 -s 10.5.2.0/24 -d 10.5.1.0/24 -m state --state NEW -j ACCEPT

# Todos los paquetes que abandonen fw por la interfaz externa y que provengan de la red interna (10.5.2.0/24)
# deben cambiar su IP de origen para que sea la de fw en esa interfaz (10.5.0.1)                                        *PREGUNTA: ¿Funcionaría igual con -i eth2 en vez de -s red?*
iptables -t nat -A POSTROUTING -o eth1 -s 10.5.2.0/24 -j SNAT --to 10.5.0.1

# Acceso TCP desde cualquier máquina (interna o externa) a la máquina dmz1 (IP 10.5.1.20), exclusivamente al servicio HTTP (puerto 80).
iptables -A FORWARD -p tcp -o eth0 -d 10.5.1.20 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

# Acceso TCP desde cualquier máquina (interna o externa) a la máquina dmz1 (IP 10.5.1.20), exclusivamente al servicio HTTPS (puerto 443).
iptables -A FORWARD -p tcp -o eth0 -d 10.5.1.20 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT

# Acceso SSH desde int1 (10.5.2.20) a dmz1 + Optional Hardening de OpenSSH Server
iptables -A FORWARD -p tcp -i eth2 -s 10.5.2.20 -o eth0 -d 10.5.1.20 -m multiport --dports 22,2222 -m state --state NEW,ESTABLISHED -j ACCEPT

# Optional Hardening de OpenSSH Server
# iptables -A FORWARD -p tcp -i eth2 -s 10.5.2.20 -o eth0 -d 10.5.1.20 --dport 2222 -m state --state NEW,ESTABLISHED -j ACCEPT