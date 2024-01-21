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
echo "Set Data classification Valid entries:O, OS, S, SUKEO, OCCAR-R, C1, C2, C3, C4"
read -p "Please set the classification of Data?" govclass
echo "Please set output file path eample: /home/<user>/Documents/"
echo "Use / for root. Leave blank to save the file in the same directory as the auditscript" 
read -p "Enter path = " outpath

# Check if the directory exists
if [ -z "$outpath" ]; then
 # If the user leaves it blank, use the current directory
   outpath="./"
   break
elif [ -d "$outpath" ]; then
   break
else
echo "Invalid path. Please enter a valid directory path."
  
fi


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
        echo "Not a valid answer Good bye."
        exit 1

fi

comp=`hostname`
today=`date +%d-%m-%Y`
output_file="BMN$bmn-$comp-system_audit-$today-$govclass.txt"
scriptn="Linux auditscript 3.6.2"

# Notice
echo "****** Security classification notice ******" 
echo User has selected classification:$clss
echo User has selected classification:$clss >$outpath$output_file

# Basic system information
echo "****** Basic System Information using hostnamectl ******">> $outpath$output_file
# Record the date and time of the audit> $outpath$output_file
date >> $outpath$output_file
hostnamectl >> $outpath$output_file
echo "****** Script version ******" >> $outpath$output_file
echo $scriptn >> $outpath$output_file
echo -e "\n" >> $outpath$output_file

# List of installed packages (Ubuntu)
if [ -n "$(command -v apt)" ]; then
  echo "****** Installed Packages apt list Ubuntu ******" >> $outpath$output_file
  apt list --installed >> $outpath$output_file
  >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  # Check apparmor
  echo "****** Checking Apparmor ******" >> $outpath$output_file
  apparmor_status >> $outpath$output_file
  echo "******  Repositories using apy-cache policy ******" >> $outpath$output_file
  # cat /etc/apt/sources.list >> $outpath$output_file
  apt-cache policy >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  echo "checking for log4j vulnerability..."  >> $outpath$output_file
  echo Checking dpkg for log4j* >> $outpath$output_file
  dpkg -l | grep log4j* >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  echo "Now doing a file check using find, search papamaeter is log4j*" >> $outpath$output_file
  find / -xdev -type f -name log4j* | grep log4j* >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  echo now checking for dependencies >> $outpath$output_file
  apt depends *log4j* >> $outpath$output_file
  echo "Note for Ubuntu Pro editions use the log4J ua script. Ubuntu '20' LTS and above Requires internet connection for updates" >> $outpath$output_file	 
  dpkg -l | grep *jdk* >> $outpath$output_file
  dpkg -l | grep *jre* >> $outpath$output_file
  dpkg -l | grep *java* >> $outpath$output_file
  dpkg -l | grep *sdk* >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
fi
# Check Snap
if [ -n "$(command -v snap)" ]; then
  echo "****** Installed Packages listed under snap snap ******" >> $outpath$output_file
  snap list >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  
fi
# Check PIP
if [ -n "$(command -v pip)" ]; then
  echo "****** Installed Packages listed under PIP python ******" >> $outpath$output_file
  pip list >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  
fi
# List of installed packages (Red Hat)
if [ -n "$(command -v yum)" ]; then
  echo "****** Installed Packages yum list installed Red Hat ******" >> $outpath$output_file
  yum list installed >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
# set source for selinux
  source /etc/sysconfig/selinux
  echo checking SELINUX /etc/sysconfig/selinux  >> $outpath$output_file
  echo SELINUX@ $SELINUX >> $outpath$output_file
  echo SELINUX TYPE: $SELINUXTYPE >> $outpath$output_file
  # Get operation mode od selinux 
  sestatus >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  #get repos
  echo "******  Repositories you repolist ******" >> $outpath$output_file
  yum repolist >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  echo "******  check for security updates red hat Note this command fails in CENTOS ******" >> $outpath$output_file
  echo "CENTOS users consider migrating to Rocky Lunx https://rockylinux.org/"
  yum updateinfo list security --installed >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  echo "checking for log4j vulnerability..."  >> $outpath$output_file
  echo Doing a file check using find, search papamaeter is log4j* >> $outpath$output_file
  echo for more ionfomation please see Red Hat web site access.redhat.com/security/vulnerabilities/RHSB-2021-009 >> $outpath$output_file
  find / -xdev -type f -name log4j* | grep log4j* >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file 
  rpm -qa *java* >> $outpath$output_file
  rpm -qa *jre* >> $outpath$output_file
  rpm -qa *jdk* >> $outpath$output_file
  rpm -qa *sdk* >> $outpath$output_file
  echo "***** Java Home if set *****" >> $outpath$output_file
  echo $JAVA_HOME >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
 
fi

# List of installed packages (SUSE)
if [ -n "$(command -v zypper)" ]; then
  echo "****** list packages using zypper SUSE ******" >> $outpath$output_file
  zypper search --installed-only >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  # apparmor 
  echo Checking apparmor for suse>> $outpath$output_file
  echo check apparmor Note SELINUX is not enbled by default and needs installing and not currently supported >> $outpath$output_file
  echo see en.opensuse.org/SDB:SELinux for more information >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  sudo apparmor_status >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  # repos check for SUSE
  zypper repos >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  # log4j lookup
  echo "checking for log4j vulnerability..."  >> $outpath$output_file
  echo Doing a file check using find, search papamaeter is log4j* >> $outpath$output_file
  echo for more ionfomation please see SUSE web site www.suse.com/c/suse-statement-on-log4j-log4shell-cve-2021-44228-vulnerability/ >> $outpath$output_file
  find / -xdev -type f -name log4j* | grep log4j* >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  echo "***** checking for java *****" >> $outpath$output_file
  java --version >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file

fi

# Users and groups
echo "****** Users and Groups cat etc/passwd & group ******" >> $outpath$output_file
cat /etc/passwd >> $outpath$output_file
echo -e "\n" >> $outpath$output_file
cat /etc/group >> $outpath$output_file
echo -e "\n" >> $outpath$output_file

# Login history 
last -F >> $outpath$output_file
echo -e "\n" >> $outpath$output_file


# Password policies
echo "****** Password Policies pwck & grpck -r ******" >> $outpath$output_file
if [ -n "$(command -v pwck)" ]; then
  pwck -r >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file

fi

if [ -n "$(command -v grpck)" ]; then
  grpck -r >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  
fi

# Check to see if the system can get to the internet
#echo "****** Test Internet ping test ******" >> $outpath$output_file
#echo internet connection test >> $outpath$output_file
#ping -c 4 8.8.8.8 >> $outpath$output_file
#echo -e "\n" >> $outpath$output_file

# echo "****** Networking tests ******" >> $outpath$output_file
#IP information 
# if [ -n "$(command -v ifconfig)" ]; then
#  echo "****** IP address information  ******" >> $outpath$output_file
#  ifconfig >> $outpath$output_file
#  echo -e "\n" >> $outpath$output_file
#  else
#  ip addr >> $outpath$output_file
#  echo -e "\n" >> $outpath$output_file
  
# fi

#public IP information 
# if [ -n "$(command -v dig)" ]; then
#  echo "****** Public Ip address & NS lookup test  ******" >> $outpath$output_file
#  dig +short myip.opendns.com @resolver1.opendns.com >> $outpath$output_file
#  dig >> $outpath$output_file
#  echo -e "\n" >> $outpath$output_file
  
# fi

#See what DNS servers can be seen from host
#echo "****** External DNS check  ******" >> $outpath$output_file
#echo testing DNS >> $outpath$output_file
#nslookup bbc.co.uk >> $outpath$output_file

# Firewall rules using ip-ables 
echo "****** Firewall rules using ip-ables  ******" >> $outpath$output_file
echo out put of fireall iptables >> $outpath$output_file
iptables -L >> $outpath$output_file
echo -e "\n" >> $outpath$output_file

# Check netstat
if [ -n "$(command -v netstat)" ]; then
  echo "****** List open ports using netstat  ******" >> $outpath$output_file
  netstat -tuln >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  echo "****** Listening Processes netstat ******" >> $outpath$output_file
  netstat -tulnp >> $outpath$output_file
  echo -e "\n" >> $outpath$output_file
  echo User has selected classification:$clss >> $outpath$output_file
   
fi

# Running services
echo "****** Running Services systemctl ******" >> $outpath$output_file
systemctl list-units --type=service >> $outpath$output_file
echo -e "\n" >> $outpath$output_file

# Check current processes useful for diagnostic work
echo running processes >> $outpath$output_file
echo -e "\n" >> $outpath$output_file
ps aux >> $outpath$output_file
echo -e "\n" >> $outpath$output_file

#Check Disk usage
echo Disk Stats >> $outpath$output_file
lsblk >> $outpath$output_file
echo -e "\n" >> $outpath$output_file

# show usb List
echo USB state >> $outpath$output_file
lsusb --tree >> $outpath$output_file
echo -e "\n" >> $outpath$output_file

# Listing hardware
lshw >> $outpath$output_file
echo -e "\n" >> $outpath$output_file
echo User has selected classification:$clss >> $outpath$output_file

echo The contents of theis script must be reviewed first before transfering to ONET >> $outpath$output_file
echo $scriptn >> $outpath$output_file
echo $outpath$output_file >> $outpath$output_file
echo Data classification is set to $clss >> $outpath$output_file
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
echo "****** Basic System Information using hostnamectl ******" >> $outpath$output_file
# Record the date and time of the audit >> $outpath$output_file
date >> $outpath$output_file

# Increment progress
((current_step++))
print_progress $current_step $total_steps

hostnamectl >> $outpath$output_file
echo "****** Script version ******" >> $outpath$output_file
echo $scriptn >> $outpath$output_file
echo -e "\n" >> $outpath$output_file

# ... (rest of your code)

# Increment progress for each section

((current_step++))
print_progress $current_step $total_steps

# List of installed packages (Ubuntu)
if [ -n "$(command -v apt)" ]; then
    echo "****** Installed Packages apt list Ubuntu ******" >> $outpath$output_file
    apt list --installed >> $outpath$output_file
    # ... (rest of the section)
fi

# Increment progress
((current_step++))
print_progress $current_step $total_steps

# Check Snap
if [ -n "$(command -v snap)" ]; then
    echo "****** Installed Packages listed under snap snap ******" >> $outpath$output_file
    snap list >> $outpath$output_file
    # ... (rest of the section)
fi

# Increment progress
((current_step++))
print_progress $current_step $total_steps

# Check PIP
if [ -n "$(command -v pip)" ]; then
    echo "****** Installed Packages listed under PIP python ******" >> $outpath$output_file
    pip list >> $outpath$output_file
    # ... (rest of the section)
fi

# ... (rest of your code)

# Increment progress for the last section
((current_step++))
print_progress $current_step $total_steps

echo -e "\n"

# ... (rest of your code)

