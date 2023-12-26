# Read me notes
# Current version auditscript 3.6.2int.sh
# next planned release auditscript 3.6.5 completed and will be released soon.
# CIS spefic scripts announced these will be the next geration od scripts CISaudit v1 in the works and will arrive 2024

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

Tested configs
I can’t test every single version of Linux, but I have written some legacy scripts for Red Hat Enterprise 4,5, and 6. These should work on all versions of Red Hat and possibly a few others that are basic.

Note that Netstat is not installed by default on most Ubuntu systems. The command will fail but it's a soft fail.
There is a slight fork for Centos 7 this file will disappear over time and will be incorporated into the main project.
Please see the data matrix.pdf for more info.

Over the next weeks and months, I will start to add error checking just to tidy things up.

Need a feature? Why not ask for it?
What other versions of the Linux test? Happy to just point me at the ISO
Feel free to contribute.

Would you like to see the process info?
Everything is shared under the GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

Need a feature? Why not ask for it!
What other versions of linux test? Hazppy to just point me at the ISO
Feel free to conbtribute.


Would you like to see process info?
Everything is shared under the GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
