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

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/client_1
export ORA_INVENTORY=/u01/app/oraInventory

if [ -f /opt/bmc/BCO/cpit ]; then
    echo "TSCO already installed, starting"
    su - bmc -c "cd /opt/bmc/BCO ; ./cpit start"
else

    # Oracle client
    echo "Installing oracle client"
    cd /opt/installers
    groupadd oinstall
    groupadd dba
    useradd -g oinstall -G dba oracle
    mkdir -pv $ORACLE_BASE
    chown -R oracle:oinstall $ORACLE_BASE
    chmod -R 775 $ORACLE_BASE
    mkdir -pv $ORA_INVENTORY
    chown -R oracle:oinstall $ORA_INVENTORY
    chmod -R 775 $ORA_INVENTORY


    unzip -q linuxx64_12201_client.zip
    chown -R oracle:oinstall /opt/installers/client

    su - oracle -c "cd /opt/installers/client ; ./runInstaller -silent -waitforcompletion -responseFile /opt/oracle_client.rsp"
    /u01/app/oraInventory/orainstRoot.sh

    groupadd bmc
    useradd -d /opt/bmc -m -g bmc -G dba bmc 

    # TSCO
    echo "Installing TSCO"
    echo "  Extracting archive"
    cd /opt/installers
    tar xzf TSCO_AppServer_ver11.0.00_Linux.tar.gz

    echo "  Encrypting DB Password"
    cd /opt/installers/BCO/Disk1
   
    BCO_OWN_PASSWORD=`echo BmcCapacity_OWN | ./BCOEncoder.sh | tail -n 1 `
    BCO_REP_PASSWORD=`echo BmcCapacity_REP | ./BCOEncoder.sh | tail -n 1 `


    echo "  Preparing options file"

    echo "-J BCO_DB_HOST=$DB_FQDN" >> /opt/tsco.conf
    echo "-J _ORACLE_HOME_=$ORACLE_HOME" >> /opt/tsco.conf
    echo "-J _ORACLE_SID_=XE" >> /opt/tsco.conf 
    echo "-J _ORACLE_SERVICENAME_=XE" >> /opt/tsco.conf
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


