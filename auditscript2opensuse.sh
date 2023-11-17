#!/bin/bash
# Writen bty Richard Wadsworth ThalesUK
# Audit script for Linux Unbuntu 14 or above and redhat 6.x and above
# Output file
output_file="system_audit.txt"

# Record the date and time of the audit
date > $output_file
# Basic system information
echo "### Basic System Information using hostnamectl ###" >> $output_file
hostnamectl >> $output_file
echo -e "\n" >> $output_file

# List of installed packages (Ubuntu)
if [ -n "$(command -v apt)" ]; then
  echo "### Installed Packages apt list Ubuntu ###" >> $output_file
  apt list --installed >> $output_file
  >> $output_file
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
  echo -e "\n" >> $output_file
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
 
fi
# List of installed packages (SUSE)
if [ -n "$(command -v zypper)" ]; then
  echo "### list packages using zypper ###" >> $output_file
  zypper search --installed-only >> $output_file
  echo -e "\n" >> $output_file
  echo check apparmor Note SELINUX is not enbled by default and needs installing >> $output_file
  sudo apparmor_status >> $output_file
  echo -e "\n" >> $output_file

fi

echo java check >> $output_file
java --version >> $output_file



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

# Firewall rules
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

echo -e "\n" >> $output_file
echo "Audit completed. Output saved to $output_file"
