# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lumaret <lumaret@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/27 01:50:55 by lumaret           #+#    #+#              #
#    Updated: 2024/01/31 18:21:26 by lumaret          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


#!/bin/bash

print_info() {
    echo "--------------------------------------------------------------------"
    echo "$1"
}

############################## SYS.ARCH + KERNELV #######################################

print_info "Architecture du systeme d'exploitation et version du kernel:"
uname -a | awk '{$2=""; print $0}'

############################## PHYSICAL CORES ###########################################

print_info "Verification du nombre de processeurs physiques et virtuels"
num_processors=$(nproc --all)
echo "Nombre de processeurs physiques et virtuels : $num_processors"

############################## RAM + PERCENT ############################################
print_info "Memoire vive disponible et taux d'utilisation:"
free --mega | grep Mem | awk '{ printf("%s/%sMB (%.1f%%)\n", $3, $2, $3/$2 * 100) }'

############################## MEMORY + PERCENT #########################################

print_info "Memoire disponible et taux d'utilisation:"
df -h / | awk 'NR==2{print $4, $5}'

############################## PROCESS USING % (Task Handler) ###########################

print_info "Taux d'utilisation des processeurs:"
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'


############################## HOUR + DATE LAST REBOOT ##################################

print_info "Date et heure du dernier redemarrage:"
who -b | awk '{print $3 " " $4}'

############################## LVM ON ? #################################################

print_info "Verification de l'etat de LVM"
if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo Inactive; else echo Active; fi

############################## NB TCP ETABLISHED ########################################

print_info "Verification du nombre de connexions TCP etablies"
tcp_connections=$(netstat -ant | grep ESTABLISHED | wc -l)
echo "Nombre de connexions TCP etablies : $tcp_connections"

############################## NB ACTIVES CONNEXIONS + NB USERS #########################

print_info "Nombre de connexions actives et d'utilisateurs:"
who

############################## IP NETWORK ###############################################

print_info "Verification de l'adresse IP reseau"
network_ip=$(ip -o -4 addr show | awk '{print $4}' | grep -v "127.0.0.1" | head -n 1)

if [ -n "$network_ip" ]; then
    echo "Adresse IP reseau : $network_ip"
else
    echo "Impossible de trouver l'adresse IP réseau."
fi

############################## IPV 4 + MAC ADRESSES #####################################

print_info "Adresses IPv4 et adresses MAC des interfaces reseau:"
ip -o addr show | awk '$3 == "inet" && $2 != "lo" && $2 != "enp0s3" {printf("%s %s\n", $2, $(NF))}'
ip link show | awk '/link/ && $2 != "lo" && $2 != "enp0s3" {printf("%s %s\n", $2, $3)}'

############################## NB SUDO COMMANDS USED ####################################
print_info "Nombre de commandes executees avec sudo:"
grep sudo /var/log/sudo/sudo.log | grep COMMAND | wc -l

exit