#!/usr/bin/env bash


# env
basedir=$(cd `dirname $0`; pwd)
workspace=${basedir}
source ${workspace}/.env

gnfddir=${workspace}/greenfield
spdir=${workspace}/greenfield-storage-provider

if [ ! -d "$gnfddir" ]; then
  git clone https://github.com/bnb-chain/greenfield.git ${gnfddir}
else
  echo "greenfield repo already exist"
fi

if [ ! -d "$spdir" ]; then
  git clone https://github.com/bnb-chain/greenfield-storage-provider.git ${spdir}
else
  echo "greenfield storage provider repo already exist"
fi


# build greenfield
echo "----------------build greenfield------------------------------"
cd ${gnfddir}
git fetch && git checkout ${GREENFIELD_TAG}
make proto-gen & make build

# get sp num
SPNUM=`grep -c OperatorAddress ${gnfddir}/sp.json`
echo "spnum: ${SPNUM}"

# build greenfield sp
echo "----------------build greenfield storage provider ------------------------------"
cd ${spdir}
git fetch && git checkout ${GREENFIELD_STORAGE_PROVIDER_TAG}
make install-tools
make build

# run greenfield
echo "----------------run greenfield blockchain ------------------------------"
cd ${gnfddir}
bash ./deployment/localup/localup.sh all 1 8
bash ./deployment/localup/localup.sh export_sps 1 8 > sp.json
cat sp.json

# run greenfield-storage-provider
echo "----------------run greenfield storage provider ------------------------------"
cd ${spdir}
sed -i -e "s/SP_NUM=[0-9]/SP_NUM=${SPNUM}/g" ${spdir}/deployment/localup/env.info
bash ./deployment/localup/localup.sh --generate ${gnfddir}/sp.json ${MYSQL_USER} ${MYSQL_PASSWORD} ${MYSQL_IP}:${MYSQL_PORT}
bash ./deployment/localup/localup.sh --reset
bash ./deployment/localup/localup.sh --start

sleep 10
ps -ef | grep gnfd-sp | wc -l
tail -n 1000 deployment/localup/local_env/sp0/gnfd-sp.log

