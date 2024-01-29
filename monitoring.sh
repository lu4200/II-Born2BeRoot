# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lucas <lucas@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/27 01:50:55 by lumaret           #+#    #+#              #
#    Updated: 2024/01/29 14:38:26 by lucas            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


#!/bin/bash

print_info() {
    echo "--------------------------------------------------------------------"
    echo "$1"
}

############################## SYS.ARCH + KERNELV #######################################

print_info "Architecture du systeme d'exploitation et version du kernel:"
uname -a

############################## PHYSICAL CORES ###########################################

print_info "Verification du nombre de processeurs physiques et virtuels"
num_processors=$(nproc --all)

echo "Nombre de processeurs physiques et virtuels : $num_processors"

############################## RAM + PERCENT ############################################

print_info "Memoire vive disponible et taux d'utilisation:"
free -h
#cat /proc/meminfo


############################## MEMORY + PERCENT #########################################

print_info "Memoire disponible et taux d'utilisation:"
df -h / | awk 'NR==2{print $4, $5}'

############################## PROCESS USING % (Task Handler) ###########################

print_info "Taux d'utilisation des processeurs:"
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
#cpu_usage=$(pgrep -u $(whoami) | xargs pmap -X | awk '/total/ {print $3}')
#echo "Taux d'utilisation des processeurs : $cpu_usage"




############################## HOUR + DATE LAST REBOOT ##################################

print_info "Date et heure du dernier redemarrage:"
who -b

############################## LVM ON ? #################################################

print_info "Verification de l'etat de LVM"
lvm_module=$(lsmod | grep "^lvm ")

if [ -n "$lvm_module" ]; then
    echo "LVM est actif sur ce systeme."
else
    echo "LVM n'est pas actif sur ce systeme."
fi
#if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo Inactive; else echo Active; fi)#####

############################## NB TCP ETABLISHED ########################################

print_info "Verification du nombre de connexions TCP etablies"
tcp_connections=$(netstat -ant | grep ESTABLISHED | wc -l)

echo "Nombre de connexions TCP etablies : $tcp_connections"

############################## NB ACTIVES CONNEXIONS + NB USERS #########################

print_info "Nombre de connexions actives et d'utilisateurs:"
who

############################## IP NETWORK ###############################################

print_info "Verification de l'adresse IP réseau"
network_ip=$(ip -o -4 addr show | awk '{print $4}' | grep -v "127.0.0.1" | head -n 1)

if [ -n "$network_ip" ]; then
    echo "Adresse IP réseau : $network_ip"
else
    echo "Impossible de trouver l'adresse IP réseau."
fi

############################## IPV 4 + MAC ADRESSES #####################################

print_info "Adresses IPv4 et adresses MAC des interfaces réseau:"
#hostname -I | awk '{print $1}'
# Adresses IPv4 et adresses MAC des interfaces réseau
ifconfig -a | grep -E "inet|ether"

############################## NB SUDO COMMANDS USED ####################################
print_info "Nombre de commandes executees avec sudo:"
grep sudo /var/log/sudo/sudo.log | grep COMMAND | wc -l

exit