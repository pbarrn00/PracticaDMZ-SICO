#!/bin/bash
# Workarround para solventar el error que aparece si en la definici´on de la red ponemos
# como gateway la IP de m´aquina que queremos que ejerza como tal (en este caso, fw).
# No podemos poner IPs repetidas en el fichero docker-compose.yml

/usr/sbin/sshd -D