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
read -p "Please enter the BMN number as a numerical number only e.g. 1234:" bmn
clear
echo "Set Data classification Valid entries: C1, C2, C3, C4"
read -p "Please set the classifcation of Data?" govclass

if [ $govclass == "O" ]; then
        clss="OFFICIAL"

elif [ $govclass == "OS" ]; then
        clss="OFFICIAL SENSITIVE"
        
elif [ $govclass == "S" ]; then
        clss="SECRET"
        
elif [ $govclass == "SUKEO" ]; then
        clss="SUKEO"
        
elif [ $govclass == "OCCAR-R" ]; then
        clss="OCCAR-RESCRICTED"

elif [ $govclass == "C1" ]; then
        clss="C1:OPEN- DESIGNED TO BE SHARED PUBLICLY"
      
elif [ $govclass == "C2" ]; then
        clss="C2:THALES GROUP LIMITED DISTRIBUTION"  
        
elif [ $govclass == "C3" ]; then
        clss="C3:THALES GROUP CONFIDENTIAL- SENSITIVE INFORMATION" 

elif [ $govclass == "C4" ]; then
        clss="C4:THALES GROUP SECRET- EXTREMELY SENSITIVE INFORMATION" 

else
        echo "Not a valid answer Good byer."
        exit 1

fi

comp=`hostname`
today=`date +%d-%m-%Y`
output_file="BMN$bmn-$comp-system_audit-$today-$govclass.txt"
scriptn="Linux auditscript 3.6.0"

# Notice
echo "****** Security classification notice ******" 
echo User has selected classification:$clss
echo User has selected classification:$clss >$output_file
# Basic system information
echo "****** Basic System Information using hostnamectl ******">> $output_file
# Record the date and time of the audit> $output_file
date >> $output_file
echo dataclassification has been set to $hmg
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
  echo Now doing a file check using find, search papamaeter is log4j* >> $output_file
  find / -type f -name log4j* | grep log4j* >> $output_file
  echo -e "\n" >> $output_file
  echo Note for Ubuntu Pro editions use the log4J ua script. Ubuntu '20' LTS and above Requires internet connection for updates >> $output_file

fi
# Check Snap
if [ -n "$(command -v snap)" ]; then
  echo "****** Installed Packages listed under snap (snap) ******" >> $output_file
  snap list >> $output_file
  >> $output_file
  echo -e "\n" >> $output_file
  
fi
# Check PIP
if [ -n "$(command -v pip)" ]; then
  echo "****** Installed Packages listed under PIP (python) ******" >> $output_file
  pip list >> $output_file
  >> $output_file
  echo -e "\n" >> $output_file
  
fi
# List of installed packages (Red Hat)
if [ -n "$(command -v yum)" ]; then
  echo "****** Installed Packages yum list installed (Red Hat) ******" >> $output_file
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
  echo "******  check for security updates red hat ******" >> $output_file
  yum updateinfo list security --installed >> $output_file
  echo -e "\n" >> $output_file
  # Check for open ports (Red hat)
  #echo "****** Open Ports netstat (Red Hat) ******" >> $output_file
  #netstat -tuln >> $output_file
  #echo -e "\n" >> $output_file
  # Check for listening processes
  #echo "****** Listening Processes netstat (Red Hat) ******" >> $output_file
  #netstat -tulnp >> $output_file
  #echo -e "\n" >> $output_file
  # log4j lookup
  echo "checking for log4j vulnerability..."  >> $output_file
  echo Doing a file check using find, search papamaeter is log4j* >> $output_file
  echo for more ionfomation please see Red Hat web site access.redhat.com/security/vulnerabilities/RHSB-2021-009 >> $output_file
  find / -type f -name log4j* | grep log4j* >> $output_file
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

  # log6j lookup
  echo "checking for log4j vulnerability..."  >> $output_file
  echo Doing a file check using find, search papamaeter is log4j* >> $output_file
  echo for more ionfomation please see SUSE web site www.suse.com/c/suse-statement-on-log4j-log4shell-cve-2021-44228-vulnerability/ >> $output_file
  find / -type f -name log4j* | grep log4j* >> $output_file
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

# Notice
echo "****** Security classification notice ******" 
echo $warn >> $output_file
echo -e "\n" >> $output_file

# Users and groups
echo "****** Users and Groups cat etcpasswd & group ******" >> $output_file
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
  echo User has selected classification:$clss >> $output_file
  
fi
# Firewall rules using ip-ables 
echo out put of fireall iptables >> $output_file
iptables -L >> $output_file
echo -e "\n" >> $output_file

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


# Check netstat
if [ -n "$(command -v netstat)" ]; then
  echo "****** List open ports using netstat  ******" >> $output_file
  netstat -tuln >> $output_file
  >> $output_file
  echo -e "\n" >> $output_file
  echo "****** Listening Processes netstat (Red Hat) ******" >> $output_file
  netstat -tulnp >> $output_file
  echo -e "\n" >> $output_file
  echo User has selected classification:$clss >> $output_file
   
fi
echo The contents of theis script must be reviewed first before transfering to ONET >> $output_file
echo $scriptn >> $output_file
echo $output_file >> $output_file
echo Data classification is set to $clss >> $output_file
echo "Audit script has completed. Please review the output file."

exit 