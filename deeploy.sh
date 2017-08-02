#!/bin/bash

#  SCRIPT DE DEPLOY DE ARQUIVOS EM SERVIDOR
#      Script criado pela equipe de dev para deploy de arquivos fonte em servidores dedicados
#      Este programa se baseia no RSYNC, sendo de extrema importância ter prévio conhecimento do mesmo para operar este script
#
#  Data de Criação : 28/07/2017
#  Autor: rmncst (Ramon Costa)


# CONFIGURAÇÕES PADRÃO PARA O DEPLOY
IGNOREFILE_NAME=".rsyncignore"
FILE_SOURCE=".deeploy-params"

#INFORMAÇÕES DOS PARÂMETROS CAPTURADOS 
CLEAR=0


#LEITURA DE PARÂMETROS
while test -n "$1"
do
	if test "$1" == "-c" | "$1" == "--clear-params"
	then
		echo "" > "$FILE_SOURCE"
		exit 0
	fi

shift
done



touch "$FILE_SOURCE"
source $FILE_SOURCE


if test "$SSH_USER" == ""
then
	echo "Informe o usuário de ssh para o deploy: "
	read SSH_USER
	echo "SSH_USER=$SSH_USER" >> "$FILE_SOURCE"
fi
if test "$SSH_PORT" == ""
then
	echo "Informe a porta do servidor SSH: "
	read SSH_PORT
	echo "SSH_PORT=$SSH_PORT" >> "$FILE_SOURCE"
fi
if test "$SERVER" == "" 
then
	echo "Informe o path do seu server: "
	read SERVER
	echo  "SERVER=$SERVER" >> "$FILE_SOURCE"
fi

if [ "$CLIENT" == "" ] 
then
	echo "Informe o path client do deploy: "
	read CLIENT
	CLIENT="$SSH_USER@$CLIENT"
	echo  "CLIENT=$CLIENT" >> "$FILE_SOURCE"
fi


echo "Deeploy Package !!! "
echo "Origem dos arquivos   ...... : $CLIENT"
echo "Destino dos arquivos  ...... : $SERVER"
echo "SSH Porta....................: $SSH_PORT"
echo "SSH User.....................: $SSH_USER"

rsync -Cavz -e "ssh -p $SSH_PORT" --exclude-from="$IGNOREFILE_NAME" "$CLIENT" "$SERVER"

exit 0

