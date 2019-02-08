#!/bin/sh
# Script para cadastrar cenários WEB.

#URL DO ZABBIX (Ex: contoso.com.br/zabbix)
ZBXURL=$1
ZBXHOSTNAME=$2

#Usuário e Senha do Zabbix
USER=$3
PASS=$4

#Nome do Cenário WEB
CWNAME="$5"

#HostID
HOSTID="$6"

HEADER='Content-Type:application/json'
#URL do Zabbix
URL='http://'$ZBXURL'/api_jsonrpc.php'
echo $URL
#Nome do Host que o cenário WEB será incluso
VHOST="$ZBXHOSTNAME"

#Nome do passo do Cenário Web
NPCW="$7"

#URL Do Cenário Web
UDCW="$8"

autenticacao()
{
    JSON='
    {
        "jsonrpc": "2.0",
        "method": "user.login",
        "params": {
            "user": "'$USER'",
            "password": "'$PASS'"
        },
        "id": 0
    }
    '
    curl -s -X POST -H "$HEADER" -d "$JSON" "$URL" | cut -d '"' -f8
}



TOKEN=$(autenticacao)
echo "--------------------------"
echo $TOKEN
echo "--------------------------"
JSON='
{
    "jsonrpc": "2.0",
    "method": "httptest.create",
    "params": {
        "name": "'$CWNAME'",
        "hostid": "'$6'",
        "steps": [
                        {
                "name": "'$7'",
                "url": "'$8'",
                "status_codes": "'$9'",
                "required": "'$10'",
                "no": "1"
            }
        ]
    },
    "auth": "'$TOKEN'",
    "id": "1"
}
'
echo $JSON |jq
echo "--------------------------"

curl -s -X POST -H "$HEADER" -d "$JSON" "$URL" |jq
