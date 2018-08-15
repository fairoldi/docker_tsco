#!/bin/sh

TSPS_FQDN=${TSPS_HOSTNAME}.${DOMAIN}
TSSO_FQDN=${TSSO_HOSTNAME}.${DOMAIN}

echo "TSPS_FQDN=$TSPS_FQDN"
echo "TSSO_FQDN=$TSSO_FQDN"
echo "DOMAIN=$DOMAIN"

export LANG=en_US.UTF-8 
export LC_ALL=en_US.UTF-8 
export LANGUAGE=en_US.UTF-8

if [ -f /opt/bmc/TrueSightPServer/truesightpserver/bin/tssh ]; then
    echo "TSPS already installed, starting"
    su - bmc -c "cd /opt/bmc/TrueSightPServer/truesightpserver/bin; ./tssh server start"
else

    echo "Adding user"
    useradd -r -d /opt/bmc -m bmc

    # TSPS
    echo "Installing TSPS"

    echo "  Extracting archive"
    cd /opt/installers
    tar xzf TrueSight_Presentation_Server_11.3.01_Linux.tar.gz 

    echo "  Generating TSPS password"
    TSPS_DB_PASSWORD=`/opt/installers/Linux/Disk1/utility/TrueSightPServerMaintenanceTool.sh -silent -encrypt -encrypt -password='Password01' -confirm_password='Password01'`
    TSSO_ADMIN_PASSWORD=`/opt/installers/Linux/Disk1/utility/TrueSightPServerMaintenanceTool.sh -silent -encrypt -encrypt -password='RSSO#Admin#' -confirm_password='RSSO#Admin#'`

    echo "  Preparing options file"
    echo "-J TrueSight_localhost_fqdn=$TSPS_FQDN" >> /opt/tsps.conf
    echo "-J TrueSight_sso_hostname=$TSSO_FQDN" >> /opt/tsps.conf
    echo "-J TrueSight_sso_password=$TSSO_ADMIN_PASSWORD" >> /opt/tsps.conf 
    echo "-J TrueSight_database_password=$TSPS_DB_PASSWORD" >> /opt/tsps.conf 
    echo "-J TrueSight_database_confirm_password=$TSPS_DB_PASSWORD" >> /opt/tsps.conf 
    cat /opt/tsps.conf

    echo "  Running prereq script"
    /opt/installers/Linux/Disk1/utility/PreinstallConfig.sh bmc
    echo "  Starting installer"
    su bmc -c "/opt/installers/Linux/Disk1/setup.bin -i silent -DOPTIONS_FILE=/opt/tsps.conf -J MINIMAL=true"
fi 

echo "Done"
sleep infinity


