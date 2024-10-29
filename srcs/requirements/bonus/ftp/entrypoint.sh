#!/bin/bash

# Configuration pour activer l'accès anonyme
sed -i 's/^anonymous_enable=NO/anonymous_enable=YES/' /etc/vsftpd.conf

# Démarre vsftpd en mode non-démon et vérifie le service
vsftpd /etc/vsftpd.conf &

# Boucle pour vérifier la disponibilité de FTP toutes les secondes
until netstat -tuln | grep :21; do
    echo "Attente du démarrage de vsftpd..."
    sleep 1
done

# Bloque le script pour empêcher le conteneur de s’arrêter
tail -f /dev/null