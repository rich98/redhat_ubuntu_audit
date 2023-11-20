# redhat_ubuntu_audit
# needs to be run as sudo in older linux versions you have to be root (su) if the user is not in the sudo group
# For detailes info see data natrix.pdf

I wanted to create a scrpt that dowa not rely on python c+ and used common linux commands.

However there are differeances between versions

In the ausitscript3.5.9 I usaed an if statement to determmine the linux version

In the ausitscript3.5.9 I used an if statement to determine the Linux version
apt = Debian based os
yum = red hat
zipper = SUSE
During the testing I found some packages where installed under pip and snap, a "if" staement has been added to check for packages 

Tested configs
I can’t test every single version of linux, but I have written some legacy scripts for red hat enterprise 4,5, and 6. These should work on all versions of red hat and possible a few others these are basic.

Note that netstat is not installed by default on most ubuntu systems. The command will fail but its a soft fail.
There is a slight fork for Centos 7 this file will disappear over time and will be incorporated in the main project.
Please see the data matrix.pdf for more info.

The CVE.sh is for ubuntu LTS 20 and above and will be update around twice a year (ish)
This tests the environment for CVE vulnerabilities likeley this will spin off in to another repo 
By the way the for Centos\Rocky yum updateinfo list security --installed command is missing, paid service in enterprise versions. TYhis will in time will get branched off properly and be maintained as its own project

Over the next weeksa months I will start to add error checking just to tidy things up.

Need a feature? Why not ask for it!
What other versions of linux test? Hazppy to just point me at the ISO
Feel free to conbtribute.

Woulkd you like to see process info?
