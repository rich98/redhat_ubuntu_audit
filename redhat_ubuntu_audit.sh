#!/bin/bash

# Output file
output_file="system_audit.txt"

# Record the date and time of the audit
date > $output_file

# Basic system information
echo "### Basic System Information ###" >> $output_file
hostnamectl >> $output_file
echo -e "\n" >> $output_file

# List of installed packages (Ubuntu)
if [ -n "$(command -v apt)" ]; then
  echo "### Installed Packages (Ubuntu) ###" >> $output_file
  apt list --installed >> $output_file
  >> $output_file
  echo Checking Apparmor >> $output_file
  apparmor_status >> $output_file
  echo "###  Repositories in Apt ###" >> $output_file
  # cat /etc/apt/sources.list >> $output_file
  apt-cache policy >> $output_file
  echo -e "\n" >> $output_file
fi

# List of installed packages (Red Hat)
if [ -n "$(command -v yum)" ]; then
  echo "### Installed Packages (Red Hat) ###" >> $output_file
  yum list installed >> $output_file
  echo -e "\n" >> $output_file
# et source for selinux
  source /etc/sysconfig/selinux
  echo checking SELINUX >> $output_file
  echo SELINUX@ $SELINUX >> $output_file
  echo SELINUX TYPE: $SELINUXTYPE >> $output_file
  echo "###  Repositories in Yum ###" >> $output_file
  yum repolist >> $output_file
  echo -e "\n" >> $output_file
 
fi

# Users and groups
echo "### Users and Groups ###" >> $output_file
cat /etc/passwd >> $output_file
echo -e "\n" >> $output_file
cat /etc/group >> $output_file
echo -e "\n" >> $output_file

# Password policies
echo "### Password Policies ###" >> $output_file
if [ -n "$(command -v pwck)" ]; then
  pwck -r >> $output_file
  echo -e "\n" >> $output_file
fi
if [ -n "$(command -v grpck)" ]; then
  grpck -r >> $output_file
  echo -e "\n" >> $output_file
fi

# Firewall rules
echo "### Firewall Rules ###" >> $output_file
if [ -n "$(command -v ufw)" ]; then
  ufw status >> $output_file
  echo -e "\n" >> $output_file
fi
if [ -n "$(command -v firewall-cmd)" ]; then
  firewall-cmd --list-all >> $output_file
  echo -e "\n" >> $output_file
fi

# Running services
echo "### Running Services ###" >> $output_file
systemctl list-units --type=service >> $output_file
echo -e "\n" >> $output_file

# Check for open ports
echo "### Open Ports ###" >> $output_file
netstat -tuln >> $output_file
echo -e "\n" >> $output_file

# Check for listening processes
echo "### Listening Processes ###" >> $output_file
netstat -tulnp >> $output_file
echo -e "\n" >> $output_file

# Check for setuid and setgid files
echo "### Setuid and Setgid Files ###" >> $output_file
find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -la {} \; >> $output_file
echo -e "\n" >> $output_file

echo "Audit completed. Output saved to $output_file"
