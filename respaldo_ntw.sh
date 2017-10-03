#!/bin/bash

archivo=bkp_ntw_$(date +%m_%d_%y)
user-FTP = "usuario"
passwd-FTP = "clave"
FTP-Server="FQDN or IP Address"
mail-rcp = "mail@dominio.corp"
$asunto-correo="texto del asunto"

cd /home/respaldoNetworking

tar cfjv $archivo.tar.bz2 /tftpboot/

ncftp -u user-FTP -p $passwd-FTP $FTP-Server << EOF
cd Networking
put $archivo.tar.bz2
quit
EOF

find -name "*.tar.bz2" -mtime +30 -exec rm -f {} \;

echo "Respaldo realizado el $(date)" | mail -s $asunto-correo $mail-rcp
