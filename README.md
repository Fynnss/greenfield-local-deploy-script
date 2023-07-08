This script help user to quickly deploy a local greenfield storage network.

## env
```
## BASIC CONFIG
GREENFIELD_TAG=28ad8fe4c8ec975aaa7d6635500cecca26959b9b
GREENFIELD_STORAGE_PROVIDER_TAG=db468e39c3e39b183a34b6a1e0971ea4a293302d

## Mysql
MYSQL_USER=root
MYSQL_PASSWORD=root
MYSQL_IP=127.0.0.1
MYSQL_PORT=3306
```

## Command
```shell
# 1 validator and 7 storage provider
bash localup_all.sh 1 7
```
