#!/bin/sh

TSCO_FQDN="${TSCO_HOSTNAME}.${DOMAIN}"
TSSO_FQDN="${TSSO_HOSTNAME}.${DOMAIN}"
TSPS_FQDN="${TSPS_HOSTNAME}.${DOMAIN}"
DB_FQDN="${DB_HOSTNAME}.${DOMAIN}"

echo "TSCO_FQDN=$TSCO_FQDN"
echo "TSPS_FQDN=$TSPS_FQDN"
echo "TSSO_FQDN=$TSSO_FQDN"
echo "DB_FQDN=$DB_FQDN"

export LANG=en_US.UTF-8 
export LC_ALL=en_US.UTF-8 
export LANGUAGE=en_US.UTF-8

if [ -f /opt/bmc/BCO/cpit ]; then
    echo "TSCO already installed, starting"
    su - bmc -c "cd /opt/bmc/BCO ; ./cpit start"
else
    # TSCO
    echo "Installing TSCO"
    echo "  Extracting archive"
    cd /opt/installers
    tar xzf TSCO_AppServer_ver11.0.00_Linux.tar.gz

    echo "  Encrypting DB Password"
    cd /opt/installers/BCO/Disk1
   
    TSCO_DB_PASSWORD=`echo postgres | ./BCOEncoder.sh postgres | tail -n 1 `
    echo "TSCO_DB_PASSWORD=$TSCO_DB_PASSWORD"
    BCO_OWN_PASSWORD=`echo BmcCapacity_OWN | ./BCOEncoder.sh | tail -n 1 `
    BCO_REP_PASSWORD=`echo BmcCapacity_REP | ./BCOEncoder.sh | tail -n 1 `


    echo "  Preparing options file"
    echo "-J BCO_DB_HOST=$DB_FQDN" >> /opt/tsco.conf
    echo "-J BCO_DB_PASSWORD=$TSCO_DB_PASSWORD" >> /opt/tsco.conf
    echo "-J BCO_RSSO_HOSTNAME=$TSSO_FQDN" >> /opt/tsco.conf
    echo "-J BCO_TSPS_HOSTNAME=$TSPS_FQDN" >> /opt/tsco.conf

    echo "-J _SECDBPWD_=$BCO_OWN_PASSWORD" >> /opt/tsco.conf
    echo "-J _SECDBREPPWD_=$BCO_REP_PASSWORD" >> /opt/tsco.conf

    cat /opt/tsco.conf


    echo "  Starting installer"
    /opt/installers/BCO/Disk1/setup.sh -i silent -DOPTIONS_FILE=/opt/tsco.conf
fi 

echo "Done"
echo 
echo "Environment up and running..."
echo "make sure your /etc/hosts file looks like this to access components"
echo "    127.0.0.1    localhost ${TSCO_FQDN} ${TSSO_FQDN} ${TSPS_FQDN} ${DB_FQDN}"
echo 
echo "Default accounts:"
echo "    RSSO       - username: Admin        password: RSSO#Admin#"
echo "    TSCO, TSPS - username: admin        password: admin12345"
echo "    DB         - username: postgres     password: postgres"
echo "    DB         - username: BCO_OWN      password: BmcCapacity_OWN"
echo "    DB         - username: BCO_REP      password: BmcCapacity_REP"
sleep infinity


