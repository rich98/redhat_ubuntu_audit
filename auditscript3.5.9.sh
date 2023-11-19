#!/bin/bash
# Writen bty Richard Wadsworth 
# Audit script for Linux Unbuntu 18 or above and redhat 7.x and above
# Output file
# set name of file
comp=`hostname`
today=`date +%d-%m-%Y`
output_file="$comp-system_audit-$today.txt"
# Record the date and time of the audit
date >> $output_file
# Basic system information
echo "### Basic System Information using hostnamectl ###" >> $output_file
hostnamectl >> $output_file
echo -e "\n" >> $output_file

# List of installed packages (Ubuntu)
if [ -n "$(command -v apt)" ]; then
  echo "### Installed Packages apt list Ubuntu ###" >> $output_file
  apt list --installed >> $output_file
  >> $output_file
  echo -e "\n" >> $output_file
  # Check apparmor
  echo Checking Apparmor >> $output_file
  apparmor_status >> $output_file
  echo "###  Repositories using apy-cache policy ###" >> $output_file
  # cat /etc/apt/sources.list >> $output_file
  apt-cache policy >> $output_file
  echo -e "\n" >> $output_file
  # Check for open ports (ubuntu needs net-tools installed)
  echo "### Open Ports netstat (Red Hat) ###" >> $output_file
  netstat -tuln >> $output_file
  echo -e "\n" >> $output_file
  echo "if output is blank net-tools might not be installed" >> $output_file
  echo -e "\n" >> $output_file
  # Check for listening processes
  echo "### Listening Processes netstat (ubuntu needs net-tools installed) ###" >> $output_file
  netstat -tulnp >> $output_file
  echo -e "\n" >> $output_file
  echo "if output is blank net-tools might not be installed" >> $output_file
  echo -e "\n" >> $output_file
  # log6j lookup
  echo "checking for log4j vulnerability..."  >> $output_file
  echo Checking dpkg for log4j* >> $output_file
  dpkg -l | grep log4j* >> $output_file
  echo -e "\n" >> $output_file
  echo Now doing a file check using find, search papamaeter is log4j* >> $output_file
  find / -type f -name log4j* >> $output_file
  echo -e "\n" >> $output_file
  echo Note for Ubuntu Pro editions use the log4J ua script. Ubuntu '20' LTS and above Requires internet connection for updates >> $output_file
  

fi

# Check Snap
if [ -n "$(command -v snap)" ]; then
  echo "### Installed Packages listed under snap Ubuntu ###" >> $output_file
  snap list >> $output_file
  >> $output_file
  echo -e "\n" >> $output_file

fi

# Check PIP
if [ -n "$(command -v pip)" ]; then
  echo "### Installed Packages listed under PIP (python) ###" >> $output_file
  pip list >> $output_file
  >> $output_file
  echo -e "\n" >> $output_file

fi


# List of installed packages (Red Hat)
if [ -n "$(command -v yum)" ]; then
  echo "### Installed Packages yum list installed Red Hat ###" >> $output_file
  yum list installed >> $output_file
  echo -e "\n" >> $output_file
# set source for selinux
  source /etc/sysconfig/selinux
  echo checking SELINUX /etc/sysconfig/selinux  >> $output_file
  echo SELINUX@ $SELINUX >> $output_file
  echo SELINUX TYPE: $SELINUXTYPE >> $output_file
  # Get operation mode od selinux 
  sestatus >> $output_file
  echo -e "\n" >> $output_file
  #get repos
  echo "###  Repositories you repolist ###" >> $output_file
  yum repolist >> $output_file
  echo -e "\n" >> $output_file
  echo "###  check for security updates red hat ###" >> $output_file
  yum updateinfo list security --installed >> $output_file
  echo -e "\n" >> $output_file
  # Check for open ports (Red hat)
  echo "### Open Ports netstat (Red Hat) ###" >> $output_file
  netstat -tuln >> $output_file
  echo -e "\n" >> $output_file
  # Check for listening processes
  echo "### Listening Processes netstat (Red Hat) ###" >> $output_file
  netstat -tulnp >> $output_file
  echo -e "\n" >> $output_file
  # log6j lookup
  echo "checking for log4j vulnerability..."  >> $output_file
  echo Doing a file check using find, search papamaeter is log4j* >> $output_file
  echo for more ionfomation please see Red Hat web site access.redhat.com/security/vulnerabilities/RHSB-2021-009 >> $output_file
  find / -type f -name log4j*
  echo -e "\n" >> $output_file
 
fi
# List of installed packages (SUSE)
if [ -n "$(command -v zypper)" ]; then
  echo "### list packages using zypper ###" >> $output_file
  zypper search --installed-only >> $output_file
  echo -e "\n" >> $output_file
  # apparmor 
  echo Checking apparmor for suse>> $output_file
  echo check apparmor Note SELINUX is not enbled by default and needs installing and not currently supported >> $output_file
  echo see en.opensuse.org/SDB:SELinux for more information >> $output_file
  echo -e "\n" >> $output_file
  sudo apparmor_status >> $output_file
  echo -e "\n" >> $output_file
  # repos check for SUSE
  zypper repos >> $output_file
  echo -e "\n" >> $output_file
  # log6j lookup
  echo "checking for log4j vulnerability..."  >> $output_file
  echo Doing a file check using find, search papamaeter is log4j* >> $output_file
  echo for more ionfomation please see SUSE web site www.suse.com/c/suse-statement-on-log4j-log4shell-cve-2021-44228-vulnerability/ >> $output_file
  find / -type f -name log4j*
  echo -e "\n" >> $output_file

fi
# In this section add checks for specfic requriemets 
#check java
echo java check >> $output_file
java --version >> $output_file
echo If java returns no value and you belive java is installed check snap output. OpenJDK installed under snap does not respond to this command >> $output_file
echo -e "\n" >> $output_file

# Users and groups
echo "### Users and Groups cat etcpasswd & group ###" >> $output_file
cat /etc/passwd >> $output_file
echo -e "\n" >> $output_file
cat /etc/group >> $output_file
echo -e "\n" >> $output_file

# Password policies
echo "### Password Policies pwck & grpck -r ###" >> $output_file
if [ -n "$(command -v pwck)" ]; then
  pwck -r >> $output_file
  echo -e "\n" >> $output_file
  
fi

if [ -n "$(command -v grpck)" ]; then
  grpck -r >> $output_file
  echo -e "\n" >> $output_file
  
fi

# Firewall rules using ip-ables 
echo out put of fireall iptables >> $output_file
iptables -L >> $output_file
echo -e "\n" >> $output_file
echo -e "\n" >> $output_file

# Running services
echo "### Running Services systemctl ###" >> $output_file
systemctl list-units --type=service >> $output_file
echo -e "\n" >> $output_file

# Check for setuid and setgid files
#echo "### Setuid and Setgid Files ###" >> $output_file
#find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -la {} \; >> $output_file
#echo -e "\n" >> $output_file

exit 
