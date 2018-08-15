#!/bin/sh

TSCO_FQDN="${TSCO_HOSTNAME}.${DOMAIN}"
RSSO_FQDN="${TSPS_HOSTNAME}.${DOMAIN}"
TSPS_FQDN="${TSPS_HOSTNAME}.${DOMAIN}"
DB_FQDN="${DB_HOSTNAME}.${DOMAIN}"

echo "TSCO_FQDN=$TSCO_FQDN"
echo "TSPS_FQDN=$TSPS_FQDN"
echo "RSSO_FQDN=$RSSO_FQDN"
echo "DB_FQDN=$DB_FQDN"

export LANG=en_US.UTF-8 
export LC_ALL=en_US.UTF-8 
export LANGUAGE=en_US.UTF-8

# TSCO
echo "Installing TSCO"
echo "  Extracting archive"
cd /opt/installers
tar xzf TSCO_AppServer_ver11.3.01_Linux.tar.gz

echo "  Encrypting DB Password"
cd /opt/installers/BCO/Disk1
./BCOEncoder.sh -genkeys
TSCO_DB_PASSWORD=`./BCOEncoder.sh $POSTGRES_PASSWORD | tail -n 2 | head -n 1`
echo "TSCO_DB_PASSWORD=$TSCO_DB_PASSWORD"
BCO_OWN_PASSWORD=`./BCOEncoder.sh BmcCapacity_OWN | tail -n 2 | head -n 1`
BCO_REP_PASSWORD=`./BCOEncoder.sh BmcCapacity_REP | tail -n 2 | head -n 1`


echo "  Preparing options file"
echo "-J BCO_DB_HOST=$DB_FQDN" >> /opt/tsco.conf
echo "-J BCO_DB_PASSWORD=$TSCO_DB_PASSWORD" >> /opt/tsco.conf
echo "-J BCO_RSSO_HOSTNAME=$RSSO_FQDN" >> /opt/tsco.conf
echo "-J BCO_TSPS_HOSTNAME=$TSPS_FQDN" >> /opt/tsco.conf

echo "-J _SECDBPWD_=$BCO_OWN_PASSWORD" >> /opt/tsco.conf
echo "-J _SECDBREPPWD_=$BCO_REP_PASSWORD" >> /opt/tsco.conf

cat /opt/tsco.conf


echo "  Starting installer"
/opt/installers/BCO/Disk1/setup.sh -i silent -DOPTIONS_FILE=/opt/tsco.conf

echo "Done"
sleep infinity


