# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lumaret <lumaret@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/24 16:16:53 by lumaret           #+#    #+#              #
#    Updated: 2024/01/24 17:07:03 by lumaret          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Fonction pour afficher l'information avec une ligne de séparation
print_info() {
    echo "--------------------------------------------------------"
    echo "$1"
}

# Afficher l'architecture du système d'exploitation et la version du noyau
print_info "Architecture du système d'exploitation et version du kernel:"
uname -a

# Afficher le nombre de processeurs physiques et virtuels
print_info "Nombre de processeurs physiques et virtuels:"
nproc --all

# Afficher la mémoire vive disponible et son taux d'utilisation en pourcentage
print_info "Mémoire vive disponible et taux d'utilisation:"
free -h

# Afficher la mémoire disponible et son taux d'utilisation en pourcentage
print_info "Mémoire disponible et taux d'utilisation:"
df -h / | awk 'NR==2{print $4, $5}'

# Afficher le taux d'utilisation des processeurs en pourcentage
print_info "Taux d'utilisation des processeurs:"
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'

# Afficher la date et l'heure du dernier redémarrage
print_info "Date et heure du dernier redémarrage:"
who -b

# Vérifier si LVM est actif ou non
print_info "LVM est-il actif?"
lvscan && vgscan && pvscan

# Afficher le nombre de connexions actives et le nombre d'utilisateurs
print_info "Nombre de connexions actives et d'utilisateurs:"
who

# Afficher l'adresse IPv4 et l'adresse MAC de toutes les interfaces réseau
print_info "Adresses IPv4 et adresses MAC des interfaces réseau:"
ip -o addr show | awk '$3 != "lo" {print $2, $4}'

# Afficher le nombre de commandes exécutées avec sudo
print_info "Nombre de commandes exécutées avec sudo:"
grep sudo /var/log/auth.log | grep COMMAND | wc -l
