#!/bin/sh

TSPS_FQDN=${TSPS_HOSTNAME}.${DOMAIN}

echo "TSPS_FQDN=$TSPS_FQDN"
echo "DOMAIN=$DOMAIN"

export LANG=en_US.UTF-8 
export LC_ALL=en_US.UTF-8 
export LANGUAGE=en_US.UTF-8

echo "Adding user"
useradd -r -d /opt/bmc -m bmc


# TSSO
echo "Installing TSSO"
echo "  Extracting archive"
cd /opt/installers
tar xzf Remedy_Single_Sign-On_for_TrueSight_Version_11.3.01_Linux.tar.gz

echo "  Generating RSSO DB passwords"
RSSO_DB_USER_PASSWORD=`/opt/installers/Disk1/utility/TrueSightRSSOMaintenanceTool.sh -silent -encrypt -encrypt -password=Password01 -confirm_password=Password01`
RSSO_DB_ADMIN_PASSWORD=`/opt/installers/Disk1/utility/TrueSightRSSOMaintenanceTool.sh -silent -encrypt -encrypt -password=Password01 -confirm_password=Password01`

echo "  Preparing options file"
echo "-J COOKIE_DOMAIN=$DOMAIN" >> /opt/tsso.conf 
echo "-J SERVER_FQDN=$TSPS_FQDN" >> /opt/tsso.conf 
echo "-J DB_USER_PWD=$RSSO_DB_USER_PASSWORD" >> /opt/tsso.conf 
echo "-J DB_USER_PWD_CNFRM=$RSSO_DB_USER_PASSWORD" >> /opt/tsso.conf 
echo "-J DB_ADMIN_PWD=$RSSO_DB_ADMIN_PASSWORD" >> /opt/tsso.conf 
echo "-J DB_ADMIN_PWD_CNFRM=$RSSO_DB_ADMIN_PASSWORD" >> /opt/tsso.conf 

echo "  Starting installer"
su bmc -c "/opt/installers/Disk1/setup.bin -i silent -DOPTIONS_FILE=/opt/tsso.conf"
su bmc -c "cd /opt/bmc/TrueSightRSSO/rsso/bin ; ./rsso server status"

echo "  Testing connection to RSSO"
curl -k -v "https://$TSPS_FQDN:8048/rsso"

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
echo "-J TrueSight_sso_hostname=$TSPS_FQDN" >> /opt/tsps.conf
echo "-J TrueSight_sso_password=$TSSO_ADMIN_PASSWORD" >> /opt/tsps.conf 
echo "-J TrueSight_database_password=$TSPS_DB_PASSWORD" >> /opt/tsps.conf 
echo "-J TrueSight_database_confirm_password=$TSPS_DB_PASSWORD" >> /opt/tsps.conf 
cat /opt/tsps.conf

echo "  Running prereq script"
/opt/installers/Linux/Disk1/utility/PreinstallConfig.sh bmc
echo "  Starting installer"
su bmc -c "/opt/installers/Linux/Disk1/setup.bin -i silent -DOPTIONS_FILE=/opt/tsps.conf -J MINIMAL=true"
cat /tmp/truesightpserver_install_log.txt

echo "Done"
sleep infinity


