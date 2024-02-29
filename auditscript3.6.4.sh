#!/bin/bash
# Written by Richard Wadsworth ThalesUK
# Audit script for Linux Ubuntu 18 or above and Red Hat 7.x and above

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Set vars
clear
read -p "Please enter the BMN number as a numerical number only e.g. 1234:" bmn
clear
echo "Set Data classification. Valid entries: O, OS, S, SUKEO, OCCAR-R, C1, C2, C3, C4"
read -p "Please set the classification of Data? " govclass
echo "Please set output file path example: /home/<user>/Documents/"
echo "Use / for root. Leave blank to save the file in the same directory as the auditscript" 
read -p "Enter path = " outpath

# Check if the directory exists
while true; do
  if [ -z "$outpath" ]; then
    # If the user leaves it blank, use the current directory
    outpath="./"
    break
  elif [ -d "$outpath" ]; then
    break
  else
    echo "Invalid path. Please enter a valid directory path."
    read -p "Enter path = " outpath
  fi
done

# Classification check
declare -A classifications
classifications=( ["O"]="OFFICIAL" ["OS"]="OFFICIAL SENSITIVE" ["S"]="SECRET" ["SUKEO"]="SUKEO" ["OCCAR-R"]="OCCAR-RESCRICTED" ["C1"]="C1:OPEN- DESIGNED TO BE SHARED PUBLICLY" ["C2"]="C2:THALES GROUP LIMITED DISTRIBUTION" ["C3"]="C3:THALES GROUP CONFIDENTIAL- SENSITIVE INFORMATION" ["C4"]="C4:THALES GROUP SECRET- EXTREMELY SENSITIVE INFORMATION" )

clss=${classifications[$govclass]}

if [ -z "$clss" ]; then
  echo "Not a valid answer. Goodbye."
  exit 1
fi

comp=`hostname`
today=`date +%d-%m-%Y`
output_file="BMN$bmn-$comp-system_audit-$today-$govclass.txt"
scriptn="Linux auditscript 3.6.2"

# Redirect all output to the file
exec >> $outpath$output_file

# Notice
echo "****** Security classification notice ******" 
echo "User has selected classification: $clss"

# Basic system information
echo "****** Basic System Information using hostnamectl ******"
# Record the date and time of the audit
date
hostnamectl
echo "****** Script version ******"
echo $scriptn
echo -e "\n"

# List of installed packages (Ubuntu)
if [ -n "$(command -v apt)" ]; then
  echo "****** Installed Packages apt list Ubuntu ******"
  apt list --installed
  echo -e "\n"
  # Check apparmor
  echo "****** Checking Apparmor ******"
  apparmor_status
  echo "******  Repositories using apt-cache policy ******"
  apt-cache policy
  echo -e "\n"
  echo "Checking for log4j vulnerability..."
  echo "Checking dpkg for log4j*"
  dpkg -l | grep log4j*
  echo -e "\n"
  echo "Now doing a file check using find, search parameter is log4j*"
  find / -xdev -type f -name 'log4j*'
  echo -e "\n"
  echo "Now checking for dependencies"
  apt depends '*log4j*'
  echo "Note for Ubuntu Pro editions use the log4J ua script. Ubuntu '20' LTS and above Requires internet connection for updates"  
  dpkg -l | grep '*jdk*'
  dpkg -l | grep '*jre*'
  dpkg -l | grep '*java*'
  dpkg -l | grep '*sdk*'
  echo -e "\n"
fi

# Check Snap
if [ -n "$(command -v snap)" ]; then
  echo "****** Installed Packages listed under snap snap ******" 
  snap list 
  echo -e "\n" 
  
fi
# Check PIP
if [ -n "$(command -v pip)" ]; then
  echo "****** Installed Packages listed under PIP python ******" 
  pip list 
  echo -e "\n" 
  
fi
# List of installed packages (Red Hat)
if [ -n "$(command -v yum)" ]; then
  echo "****** Installed Packages yum list installed Red Hat ******" 
  yum list installed 
  echo -e "\n" 
# set source for selinux
  source /etc/sysconfig/selinux
  echo checking SELINUX /etc/sysconfig/selinux  
  echo SELINUX@ $SELINUX 
  echo SELINUX TYPE: $SELINUXTYPE 
  # Get operation mode od selinux 
  sestatus 
  echo -e "\n" 
  #get repos
  echo "******  Repositories you repolist ******" 
  yum repolist 
  echo -e "\n" 
  echo "******  check for security updates red hat Note this command fails in CENTOS ******" 
  echo "CENTOS users consider migrating to Rocky Lunx https://rockylinux.org/"
  yum updateinfo list security --installed 
  echo -e "\n" 
  echo "checking for log4j vulnerability..."  
  echo Doing a file check using find, search papamaeter is log4j* 
  echo for more ionfomation please see Red Hat web site access.redhat.com/security/vulnerabilities/RHSB-2021-009 
  find / -xdev -type f -name log4j* | grep log4j* 
  echo -e "\n" 
  rpm -qa *java* 
  rpm -qa *jre* 
  rpm -qa *jdk* 
  rpm -qa *sdk* 
  echo "***** Java Home if set *****" 
  echo $JAVA_HOME 
  echo -e "\n" 
 
fi

# List of installed packages (SUSE)
if [ -n "$(command -v zypper)" ]; then
  echo "****** list packages using zypper SUSE ******" 
  zypper search --installed-only 
  echo -e "\n" 
  # apparmor 
  echo Checking apparmor for suse
  echo check apparmor Note SELINUX is not enbled by default and needs installing and not currently supported 
  echo see en.opensuse.org/SDB:SELinux for more information 
  echo -e "\n" 
  sudo apparmor_status 
  echo -e "\n" 
  # repos check for SUSE
  zypper repos 
  echo -e "\n" 
  # log4j lookup
  echo "checking for log4j vulnerability..."  
  echo Doing a file check using find, search papamaeter is log4j* 
  echo for more ionfomation please see SUSE web site www.suse.com/c/suse-statement-on-log4j-log4shell-cve-2021-44228-vulnerability/ 
  find / -xdev -type f -name log4j* | grep log4j* 
  echo -e "\n" 

fi
  echo "***** checking for java *****" 
  java --version 
  echo -e "\n" 
# Users and groups
echo "****** Users and Groups cat etc/passwd & group ******" 
cat /etc/passwd 
echo -e "\n" 
cat /etc/group 
echo -e "\n" 

# Login history 
last -F 
echo -e "\n" 


# Password policies
echo "****** Password Policies pwck & grpck -r ******" 
if [ -n "$(command -v pwck)" ]; then
  pwck -r 
  echo -e "\n" 

fi

if [ -n "$(command -v grpck)" ]; then
  grpck -r 
  echo -e "\n" 
  
fi

# Check to see if the system can get to the internet
#echo "****** Test Internet ping test ******" 
#echo internet connection test 
#ping -c 4 8.8.8.8 
#echo -e "\n" 

# echo "****** Networking tests ******" 
#IP information 
# if [ -n "$(command -v ifconfig)" ]; then
#  echo "****** IP address information  ******" 
#  ifconfig 
#  echo -e "\n" 
#  else
#  ip addr 
#  echo -e "\n" 
  
# fi

#public IP information 
# if [ -n "$(command -v dig)" ]; then
#  echo "****** Public Ip address & NS lookup test  ******" 
#  dig +short myip.opendns.com @resolver1.opendns.com 
#  dig 
#  echo -e "\n" 
  
# fi

#See what DNS servers can be seen from host
#echo "****** External DNS check  ******" 
#echo testing DNS 
#nslookup bbc.co.uk 

# Firewall rules using ip-ables 
echo "****** Firewall rules using ip-ables  ******" 
echo out put of fireall iptables 
iptables -L 
echo -e "\n" 

# Check netstat
if [ -n "$(command -v netstat)" ]; then
  echo "****** List open ports using netstat  ******" 
  netstat -tuln 
  echo -e "\n" 
  echo "****** Listening Processes netstat ******" 
  netstat -tulnp 
  echo -e "\n" 
  echo User has selected classification:$clss 
   
fi

# Running services
echo "****** Running Services systemctl ******" 
systemctl list-units --type=service 
echo -e "\n" 

# Check current processes useful for diagnostic work
echo running processes 
echo -e "\n" 
ps aux 
echo -e "\n" 

#Check Disk usage
echo Disk Stats 
lsblk 
echo -e "\n" 

# show usb List
echo USB state 
lsusb --tree 
echo -e "\n" 

# Listing hardware
lshw 
echo -e "\n" 
echo User has selected classification:$clss 

echo The contents of theis script must be reviewed first before transfering to ONET 
echo $scriptn 
echo $outpath$output_file 
echo Data classification is set to $clss 
echo "Audit script has completed. Please review the output file."
if [ $? -eq 0 ]
then
	echo "The audit scriot ran sussessfully" 
else
	echo "Something went wrong, investigate"
	exit 1
fi
exit 

# Function to print progress bar
print_progress() {
    local progress=$1
    local length=$2
    local i

    printf "["
    for ((i = 0; i < length; i++)); do
        if [ $i -lt $progress ]; then
            printf "#"
        else
            printf "-"
        fi
    done
    printf "] %d%%\r" $((progress * 100 / length))
}

# Set the total number of steps for the progress bar
total_steps=20

# ... (your existing code)

# Basic system information
echo "****** Basic System Information using hostnamectl ******" 
# Record the date and time of the audit 
date 

# Increment progress
((current_step++))
print_progress $current_step $total_steps

hostnamectl 
echo "****** Script version ******" 
echo $scriptn 
echo -e "\n" 

# ... (rest of your code)

# Increment progress for each section

((current_step++))
print_progress $current_step $total_steps

# List of installed packages (Ubuntu)
if [ -n "$(command -v apt)" ]; then
    echo "****** Installed Packages apt list Ubuntu ******" 
    apt list --installed 
    # ... (rest of the section)
fi

# Increment progress
((current_step++))
print_progress $current_step $total_steps

# Check Snap
if [ -n "$(command -v snap)" ]; then
    echo "****** Installed Packages listed under snap snap ******" 
    snap list 
    # ... (rest of the section)
fi

# Increment progress
((current_step++))
print_progress $current_step $total_steps

# Check PIP
if [ -n "$(command -v pip)" ]; then
    echo "****** Installed Packages listed under PIP python ******" 
    pip list 
    # ... (rest of the section)
fi

# ... (rest of your code)

# Increment progress for the last section
((current_step++))
print_progress $current_step $total_steps

echo -e "\n"

# ... (rest of your code)

