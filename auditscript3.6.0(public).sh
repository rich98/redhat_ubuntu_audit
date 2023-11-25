#!/bin/bash
# Writen bty Richard Wadsworth 
# Audit script for Linux Unbuntu 18 or above and redhat 7.x and above
# Check if the script is run as root
# Run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 
fi

# Set vars
clear
read -p "enter the helpdest request number or hit enter to leave this blank:" helpn
clear
echo "Set Data classification Valid entries:Open, Confidential, Secret"
read -p "Please set the classifcation of Data?" govclass

if [ $govclass == "Confidential" ]; then
        clss="Confidential"
        
elif [ $govclass == "Secret" ]; then
        clss="Secret"

elif [ $govclass == "Open" ]; then
        clss="Open"
        
else
        echo "Not a valid answer Good bye."
        exit 1

fi

comp=`hostname`
today=`date +%d-%m-%Y`
output_file="$helpn-$comp-system_audit-$today-$clss.txt"
scriptn="Linux auditscript 3.6.0"

# Notice

echo "****** Security classification notice ******" 
date >> $output_file
echo User has selected classification:$clss
echo User has selected classification:$clss >$output_file
# Basic system information
echo "****** Basic System Information using hostnamectl ******">> $output_file
# Record the date and time of the audit> $output_file
hostnamectl >> $output_file
echo -e "\n" >> $output_file
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
  echo Now doing a file check using find, search papamaeter is log4j* >> $output_file
  find / -xdev -type f -name log4j* | grep log4j* >> $output_file 2> /dev/null
  echo -e "\n" >> $output_file
  echo Note for Ubuntu Pro editions use the log4J ua script. Ubuntu '20' LTS and above Requires internet connection for updates >> $output_file

fi

#Check pacjkage managers
echo "****** Checking package managers ******" >> $output_file
echo -e "\n" >> $output_file
# Check Snap
if [ -n "$(command -v snap)" ]; then
  echo "****** snap found ******" >> $output_file
  snap list >> $output_file
  >> $output_file
  echo -e "\n" >> $output_file
  
fi
# Check PIP
if [ -n "$(command -v pip)" ]; then
  echo "****** python (pip) found ******" >> $output_file
  pip list >> $output_file
  >> $output_file
  echo -e "\n" >> $output_file
  
fi
# List of installed packages (Red Hat)
if [ -n "$(command -v yum)" ]; then
  echo "****** yum Red Hat based OS ******" >> $output_file
  yum list installed >> $output_file
  echo -e "\n" >> $output_file
  echo "****** rpm Red Hat based OS ******" >> $output_file
  rpm -qa >> $output_file
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
  echo "******  check for security updates red hat ******" >> $output_file
  yum updateinfo list security --installed >> $output_file
  echo -e "\n" >> $output_file
  echo "checking for log4j vulnerability..."  >> $output_file
  echo Doing a file check using find, search papamaeter is log4j* >> $output_file
  echo for more ionfomation please see Red Hat web site access.redhat.com/security/vulnerabilities/RHSB-2021-009 >> $output_file
  find / -xdev -type f -name log4j* | grep log4j*  >> $output_file
  echo -e "\n" >> $output_file
 
fi

# List of installed packages (SUSE)
if [ -n "$(command -v zypper)" ]; then
  echo "****** zypper OpenSUSE\SUSE based OS ******" >> $output_file
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
  echo User has selected classification:$clss >> $output_file

fi
# In this section add checks for specific requirements 

#check java
if [ -n "$(command -v java)" ]; then
  echo Java has benn detected >> $output_file	 
  java --version >> $output_file
  echo -e "\n" >> $output_file
  
fi

# Users and groups
echo "****** Users and Groups checks ******" >> $output_file
cat /etc/passwd >> $output_file
echo -e "\n" >> $output_file
cat /etc/group >> $output_file
echo -e "\n" >> $output_file

# Login history 
echo "****** Last logged on ******" >> $output_file
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
  
echo "****** Networking tests ******" >> $output_file
#IP information 
 if [ -n "$(command -v ifconfig)" ]; then
  echo "****** IP address information  ******" >> $output_file
  ifconfig >> $output_file
  echo -e "\n" >> $output_file
  else
  ip addr >> $output_file
  echo -e "\n" >> $output_file
  
 fi

#public IP information 
 if [ -n "$(command -v dig)" ]; then
  echo "****** Public Ip address lookup test  ******" >> $output_file
  dig +short myip.opendns.com @resolver1.opendns.com >> $output_file
  echo -e "\n" >> $output_file
  
 fi

# Check to see if the system can get to the internet
echo "****** Test internet ping test ******" >> $output_file
echo internet connection test >> $output_file
ping -c 4 8.8.8.8 >> $output_file
echo -e "\n" >> $output_file

# Firewall rules using ip-ables 
echo "****** Firewall rules using ip-ables  ******" >> $output_file
echo out put of fireall iptables >> $output_file
iptables -L >> $output_file
echo -e "\n" >> $output_file

#See what DNS servers can be seen from host
echo "****** External DNS check  ******" >> $output_file
echo testing DNS >> $output_file
nslookup bbc.co.uk >> $output_file

# Check netstat
if [ -n "$(command -v netstat)" ]; then
  echo "****** List open ports using netstat  ******" >> $output_file
  netstat -tuln >> $output_file
  echo -e "\n" >> $output_file
  echo "****** Listening Processes netstat (Red Hat) ******" >> $output_file
  netstat -tulnp >> $output_file
  echo -e "\n" >> $output_file
  echo User has selected classification:$clss >> $output_file
   
fi

# Check current processes useful for diagnostic work
echo "****** Running Processes ******" >> $output_file
echo running processes >> $output_file
echo -e "\n" >> $output_file
ps aux >> $output_file
echo -e "\n" >> $output_file

# Running services
echo "****** Running Services systemctl ******" >> $output_file
systemctl list-units --type=service >> $output_file
echo -e "\n" >> $output_file

#Check Disk usage
echo "****** Disk Stats ******" >> $output_file
echo Disk Stats >> $output_file
lsblk >> $output_file
echo -e "\n" >> $output_file

# show usb List
echo "****** USB stats ******" >> $output_file
echo USB state >> $output_file
lsusb --tree >> $output_file
echo -e "\n" >> $output_file

# Listing hardware
echo "****** Hardware stats ******" >> $output_file
lshw >> $output_file
echo -e "\n" >> $output_file
echo "****** Close out information  ******" >> $output_file
echo $scriptn >> $output_file
echo $output_file >> $output_file
echo Data classification is set to $clss >> $output_file
echo The contents of theis script must be reviewed first before emailing >> $output_file
echo "Audit script has completed. Please review the output file."

exit 1

