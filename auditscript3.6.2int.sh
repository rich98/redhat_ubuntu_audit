#!/bin/bash
# Writen bty Richard Wadsworth ThalesUK
# Audit script for Linux Unbuntu 18 or above and redhat 7.x and above
# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 
fi

# Set vars
clear
read -p "Please enter a audit ref:" bmn
clear
echo "Set Data classification Valid entries:OPEN, LIMITED, CONFIDENTIAL, SECRET"
read -p "Please set the classification of Data?" govclass

if [ $govclass == "OPEN" ]; then
        clss="OPEN:OPEN- DESIGNED TO BE SHARED PUBLICLY"
      
elif [ $govclass == "LIMITED" ]; then
        clss="CONTROLLED:LIMITED DISTRIBUTION"  
        
elif [ $govclass == "CONFIDENTIAL" ]; then
        clss="CONFIDENTIAL: SENSITIVE INFORMATION" 

elif [ $govclass == "SECRET" ]; then
        clss="SECRET:- EXTREMELY SENSITIVE INFORMATION" 

else
        echo "Not a valid answer Good byer."
        exit 1

fi

comp=`hostname`
today=`date +%d-%m-%Y`
output_file="BMN$bmn-$comp-system_audit-$today-$govclass.txt"
scriptn="Linux auditscript 3.6.2"

# Notice
echo "****** Security classification notice ******" 
echo User has selected classification:$clss
echo User has selected classification:$clss >$output_file

# Basic system information
echo "****** Basic System Information using hostnamectl ******">> $output_file
# Record the date and time of the audit> $output_file
date >> $output_file
hostnamectl >> $output_file
echo "****** Script version ******" >> $output_file
echo $scriptn >> $output_file
echo -e "\n" >> $output_file

# List of installed packages (Ubuntu)
if [ -n "$(command -v apt)" ]; then
  echo "****** Installed Packages apt list Ubuntu ******" >> $output_file
  apt list --installed >> $output_file
  >> $output_file
  echo -e "\n" >> $output_file
  # Check apparmor
  echo "****** Checking Apparmor ******" >> $output_file
  apparmor_status >> $output_file
  echo "******  Repositories using apy-cache policy ******" >> $output_file
  # cat /etc/apt/sources.list >> $output_file
  apt-cache policy >> $output_file
  echo -e "\n" >> $output_file
  echo "checking for log4j vulnerability..."  >> $output_file
  echo Checking dpkg for log4j* >> $output_file
  dpkg -l | grep log4j* >> $output_file
  echo -e "\n" >> $output_file
  echo "Now doing a file check using find, search papamaeter is log4j*" >> $output_file
  find / -xdev -type f -name log4j* | grep log4j* >> $output_file
  echo -e "\n" >> $output_file
  echo now checking for dependencies >> $output_file
  apt depends *log4j* >> $output_file
  echo "Note for Ubuntu Pro editions use the log4J ua script. Ubuntu '20' LTS and above Requires internet connection for updates" >> $output_file	 
  dpkg -l | grep *jdk* >> $output_file
  dpkg -l | grep *jre* >> $output_file
  dpkg -l | grep *java* >> $output_file
  dpkg -l | grep *sdk* >> $output_file
  echo -e "\n" >> $output_file
fi
# Check Snap
if [ -n "$(command -v snap)" ]; then
  echo "****** Installed Packages listed under snap snap ******" >> $output_file
  snap list >> $output_file
  echo -e "\n" >> $output_file
  
fi
# Check PIP
if [ -n "$(command -v pip)" ]; then
  echo "****** Installed Packages listed under PIP python ******" >> $output_file
  pip list >> $output_file
  echo -e "\n" >> $output_file
  
fi
# List of installed packages (Red Hat)
if [ -n "$(command -v yum)" ]; then
  echo "****** Installed Packages yum list installed Red Hat ******" >> $output_file
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
  echo "******  Repositories you repolist ******" >> $output_file
  yum repolist >> $output_file
  echo -e "\n" >> $output_file
  echo "******  check for security updates red hat Note this command fails in CENTOS ******" >> $output_file
  echo "CENTOS users consider migrating to Rocky Lunx https://rockylinux.org/"
  yum updateinfo list security --installed >> $output_file
  echo -e "\n" >> $output_file
  echo "checking for log4j vulnerability..."  >> $output_file
  echo Doing a file check using find, search papamaeter is log4j* >> $output_file
  echo for more ionfomation please see Red Hat web site access.redhat.com/security/vulnerabilities/RHSB-2021-009 >> $output_file
  find / -xdev -type f -name log4j* | grep log4j* >> $output_file
  echo -e "\n" >> $output_file 
  rpm -qa *java* >> $output_file
  rpm -qa *jre* >> $output_file
  rpm -qa *jdk* >> $output_file
  rpm -qa *sdk* >> $output_file
  echo "***** Java Home if set *****" >> $output_file
  echo $JAVA_HOME >> $output_file
  echo -e "\n" >> $output_file
 
fi

# List of installed packages (SUSE)
if [ -n "$(command -v zypper)" ]; then
  echo "****** list packages using zypper SUSE ******" >> $output_file
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
  # log4j lookup
  echo "checking for log4j vulnerability..."  >> $output_file
  echo Doing a file check using find, search papamaeter is log4j* >> $output_file
  echo for more ionfomation please see SUSE web site www.suse.com/c/suse-statement-on-log4j-log4shell-cve-2021-44228-vulnerability/ >> $output_file
  find / -xdev -type f -name log4j* | grep log4j* >> $output_file
  echo -e "\n" >> $output_file
  echo "***** checking for java *****" >> $output_file
  java --version >> $output_file
  echo -e "\n" >> $output_file

fi

if [ -n "$(command -v java)" ]; then
  echo "****** java test results******" >> $output_file
  java --version >> $output_file
  echo -e "\n" >> $output_file
fi

# Users and groups
echo "****** Users and Groups cat etc/passwd & group ******" >> $output_file
cat /etc/passwd >> $output_file
echo -e "\n" >> $output_file
cat /etc/group >> $output_file
echo -e "\n" >> $output_file

# Login history 
last -F >> $output_file
echo -e "\n" >> $output_file


# Password policies
echo "****** Password Policies pwck & grpck -r ******" >> $output_file
if [ -n "$(command -v pwck)" ]; then
  pwck -r >> $output_file
  echo -e "\n" >> $output_file

fi

if [ -n "$(command -v grpck)" ]; then
  grpck -r >> $output_file
  echo -e "\n" >> $output_file
  
fi

# Check to see if the system can get to the internet
#echo "****** Test Internet ping test ******" >> $output_file
#echo internet connection test >> $output_file
#ping -c 4 8.8.8.8 >> $output_file
#echo -e "\n" >> $output_file

# echo "****** Networking tests ******" >> $output_file
#IP information 
# if [ -n "$(command -v ifconfig)" ]; then
#  echo "****** IP address information  ******" >> $output_file
#  ifconfig >> $output_file
#  echo -e "\n" >> $output_file
#  else
#  ip addr >> $output_file
#  echo -e "\n" >> $output_file
  
# fi

#public IP information 
# if [ -n "$(command -v dig)" ]; then
#  echo "****** Public Ip address & NS lookup test  ******" >> $output_file
#  dig +short myip.opendns.com @resolver1.opendns.com >> $output_file
#  dig >> $output_file
#  echo -e "\n" >> $output_file
  
# fi

#See what DNS servers can be seen from host
#echo "****** External DNS check  ******" >> $output_file
#echo testing DNS >> $output_file
#nslookup bbc.co.uk >> $output_file

# Firewall rules using ip-ables 
echo "****** Firewall rules using ip-ables  ******" >> $output_file
echo out put of fireall iptables >> $output_file
iptables -L >> $output_file
echo -e "\n" >> $output_file

# Check netstat
if [ -n "$(command -v netstat)" ]; then
  echo "****** List open ports using netstat  ******" >> $output_file
  netstat -tuln >> $output_file
  echo -e "\n" >> $output_file
  echo "****** Listening Processes netstat ******" >> $output_file
  netstat -tulnp >> $output_file
  echo -e "\n" >> $output_file
  echo User has selected classification:$clss >> $output_file
   
fi

# Running services
echo "****** Running Services systemctl ******" >> $output_file
systemctl list-units --type=service >> $output_file
echo -e "\n" >> $output_file

# Check current processes useful for diagnostic work
echo running processes >> $output_file
echo -e "\n" >> $output_file
ps aux >> $output_file
echo -e "\n" >> $output_file

#Check Disk usage
echo Disk Stats >> $output_file
lsblk >> $output_file
echo -e "\n" >> $output_file

# show usb List
echo USB state >> $output_file
lsusb --tree >> $output_file
echo -e "\n" >> $output_file

# Listing hardware
lshw >> $output_file
echo -e "\n" >> $output_file
echo User has selected classification:$clss >> $output_file

echo The contents of theis script must be reviewed first before transfering to ONET >> $output_file
echo $scriptn >> $output_file
echo $output_file >> $output_file
echo Data classification is set to $clss >> $output_file
echo "Audit script has completed. Please review the output file."

exit 
