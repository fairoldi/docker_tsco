#!/bin/sh

TSSO_FQDN=${TSSO_HOSTNAME}.${DOMAIN}

echo "TSSO_FQDN=$TSSO_FQDN"
echo "DOMAIN=$DOMAIN"

export LANG=en_US.UTF-8 
export LC_ALL=en_US.UTF-8 
export LANGUAGE=en_US.UTF-8

if [ -f /opt/bmc/TrueSightRSSO/rsso/bin/rsso ]; then
    echo "TSSO already installed, starting"
    su - bmc -c "cd /opt/bmc/TrueSightRSSO/rsso/bin/; ./rsso server start"
else

    echo "Adding user"
    useradd -r -d /opt/bmc -m bmc

    # TSSO
    echo "Installing TSSO"
    echo "  Extracting archive"
    cd /opt/installers
    tar xzf Remedy_Single_Sign-On_for_TrueSight_Version_11.0_Linux.tar.gz

    echo "  Generating RSSO DB passwords"
    chmod +x /opt/installers/Disk1/utility/TrueSightRSSOMaintenanceTool.sh
    TSSO_DB_USER_PASSWORD=`/opt/installers/Disk1/utility/TrueSightRSSOMaintenanceTool.sh -silent -encrypt -encrypt -password=Password01 -confirm_password=Password01`
    TSSO_DB_ADMIN_PASSWORD=`/opt/installers/Disk1/utility/TrueSightRSSOMaintenanceTool.sh -silent -encrypt -encrypt -password=Password01 -confirm_password=Password01`

    echo "  Preparing options file"
    echo "-J COOKIE_DOMAIN=$DOMAIN" >> /opt/tsso.conf 
    echo "-J SERVER_FQDN=$TSSO_FQDN" >> /opt/tsso.conf 
    echo "-J DB_USER_PWD=$TSSO_DB_USER_PASSWORD" >> /opt/tsso.conf 
    echo "-J DB_USER_PWD_CNFRM=$TSSO_DB_USER_PASSWORD" >> /opt/tsso.conf 
    echo "-J DB_ADMIN_PWD=$TSSO_DB_ADMIN_PASSWORD" >> /opt/tsso.conf 
    echo "-J DB_ADMIN_PWD_CNFRM=$TSSO_DB_ADMIN_PASSWORD" >> /opt/tsso.conf 

    echo "  Starting installer"
    su bmc -c "/opt/installers/Disk1/setup.bin -i silent -DOPTIONS_FILE=/opt/tsso.conf"
    su bmc -c "cd /opt/bmc/TrueSightRSSO/rsso/bin ; ./rsso server status"
fi 

echo "Done"
sleep infinity


