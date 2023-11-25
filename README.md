# auditscript3.6.0(public).sh

OS notes. For some tools to work on debian based systems such as ubuntu and raspbian PI make sure net-tools and dns utils are installed

sudo apt(-get) install net-tools
sudo apt(-get) install dnsutils

Makesure lshw is installed for Open SUSE

Fixes
fix an error with find when looking for log4j - find / -xdsev -type f -name log4j* | grep log4j* >> $output_file

Changes & improvements
1. At the start of the script the user is asked for a helpdesk\jira\request ticket number - This can be left blank. If entered the number is refixed to the outputfile name.
2. Classifion of data. Options Open, Confidential, Secret. you can change these and they only have to be updared in the "#set vars" section of the script
3. $warn depricated and removed
4. Order of checks changed to be more consistant by type
5. Java check now only runs if present (If statement to see if java is installed)
                 Note: If jav is installed under snap java command does not work
6. Login history is now added7. The following ip address information is collected or checked. (for ubuntu net-tools neds to be installed. The script checks by doing an if statement to see if the tools are loaded)
   IPaddress - Pubic IP address (if connected to the internet) - ping test to Google DNS server 8.8.8.8 - nslookup test uses bbc.co.uk
7. Current running processes are now captured
8. Disk information is captured
9. USB information is captured
10. Full hardware list is now captured
11. Checks that root (sudo) is being used

Full capability of audit script
run as  root
set vars
set helpdesk\JIAR\Git ticket numer
Set Classification of data (Based on DoD) you may update these settings to your requirements 
Basic System - Identifies if instance is running on haredware or hypervisior 
List installed software check forpackage managers
  apt
  snap
  pip
  yum
  rpm
  zypper
  Java check
  Users & Groups
  login history
  password policies 
  Ip information: IPaddress - Pubic IP address (if connected to the internet) - ping test to Google DNS server 8.8.8.8 - nslookup test uses bbc.co.uk
  Running processes
  Disk Information
  USB information
  General Hardware information 

  Tested on 
  Red hat 9,8,7
  Ubuntu 16LTS, 18LTS, 22LTS, MINT CSI Linux 2023.2, and kali 2023
  Oracle Linux 9,8
  Raspberry Pi (Debian bullseye)
  Open SUSE tumbleweed

  If you want me to test on any other version please let me know by creating an issue.
