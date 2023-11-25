# Read me notes
# Current version auditscript 3.5.9.1sh
# next planned release auditscript 3.6.0
# bug fix for finding log4j


Notes
Needs to be run as sudo in older Linux versions you have to be root (su) if the user is not in the sudo group
For details info see data natrix.pdf

What is being audited?
Static Hostname
Transient Hostname
Icon Namw
Chassis
Machine and Boot IDs
Virtualization
Operating system Name
CPE OS Name
Kernel
Architecture
Firmware
Instakked packages apt, yum,zypper,snap, and pip
iptables
netstat (if tools installed) Note this does not record current IP but is an easy add
selinux OR Apparmor
User and group list
Java check
Password policies
Running services

I wanted to create a scrpt that did not rely on Python c+ and used common Linux commands.

However, there are differences between versions

In the ausitscript3.5.9 I used an if statement to determine the Linux version

In the ausitscript3.5.9 I used an if statement to determine the Linux version
apt = Debian-based os
yum = red hat
zipper = SUSE
During the testing, I found some packages were installed under pip and snap, a "if" statement has been added to check for packages 

Tested configs
I can’t test every single version of Linux, but I have written some legacy scripts for Red Hat Enterprise 4,5, and 6. These should work on all versions of Red Hat and possibly a few others that are basic.

Note that Netstat is not installed by default on most Ubuntu systems. The command will fail but it's a soft fail.
There is a slight fork for Centos 7 this file will disappear over time and will be incorporated into the main project.
Please see the data matrix.pdf for more info.

The CVE.sh is for Ubuntu LTS 20 and above and will be updated around twice a year (ish)
This tests the environment for CVE vulnerabilities likely this will spin off into another repo 
By the way the Centos\Rocky yum updateinfo list security --installed command is missing, paid service in enterprise versions. TYhis will in time get branched off properly and be maintained as its own project

Over the next weeks and months, I will start to add error checking just to tidy things up.

Need a feature? Why not ask for it?
What other versions of the Linux test? Happy to just point me at the ISO
Feel free to contribute.

Would you like to see the process info?
Everything is shared under the GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

Need a feature? Why not ask for it!
What other versions of linux test? Happy to just point me at the ISO
Feel free to conbtribute.

Auditscript 3.6.0 coming soon
 - last logged on history
 - Scheck running as sudo
 - and more....



Would you like to see process info?
Everything is shared under the GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
