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
During the testing I found some packages where installed under pip and snap, an if statement was used here also.
Tested configs
I can’t test every single version of red hat – also I have written dome legacy scripts for red 6 and below. These should work on all versions of Linux but are very basic.
Note that netstat is not installed by default on most ubuntu systems.
There is a slight fork for Centos 7 this file will disappear over time and will be incorporated in the main project.
Please see the data matrix.pdf for more info.
The CVE.sh is for ubuntu LTS 20 and above and will be update around twice a year (ish)
This tests the environment for CVE vulnerabilities.
