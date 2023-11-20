#!/bin/bash

# Simple Audit Script for Red Hat Enterprise Linux 6

# Output file for audit results
output_file="audit_results.txt"

# Function to print section headers in the output file
print_section_header() {
    echo "--------------------------------------------------" >> "$output_file"
    echo "$1" >> "$output_file"
    echo "--------------------------------------------------" >> "$output_file"
}

# Function to check and log commands
check_and_log() {
    echo "Executing: $1"
    eval "$1" >> "$output_file" 2>&1
    echo -e "Result:\n$(tail -n 5 $output_file)\n"
}

# Start auditing

# Record date and time
date > "$output_file"

# Print system information
print_section_header "System Information"
check_and_log "hostnamectl"
check_and_log "cat /etc/redhat-release"
check_and_log "uname -a"
check_and_log "df -h"
check_and_log "free -m"

# Print user information
print_section_header "User Information"
check_and_log "cat /etc/passwd"
check_and_log "cat /etc/group"

# Print network information
print_section_header "Network Information"
check_and_log "ifconfig -a"
check_and_log "netstat -tuln"
check_and_log "iptables -L"

# Print running processes
print_section_header "Running Processes"
check_and_log "ps aux"

# Print open files
print_section_header "Open Files"
check_and_log "lsof"

# Print cron jobs
print_section_header "Cron Jobs"
check_and_log "crontab -l"

# Print listening ports
print_section_header "Listening Ports"
check_and_log "netstat -tuln"

# Print SELinux status
print_section_header "SELinux Status"
check_and_log "sestatus"

# End of audit
echo "Audit completed. Results are stored in $output_file"
