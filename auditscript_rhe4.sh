#!/bin/bash

# Red Hat Enterprise Linux 4 Audit Script

# Output file
OUTPUT_FILE="audit_report.txt"

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Function to check and log system information
log_system_info() {
  echo "System Information" >> "$OUTPUT_FILE"
  echo "------------------" >> "$OUTPUT_FILE"
  uname -a >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
}

# Function to check and log user accounts
log_user_accounts() {
  echo "User Accounts" >> "$OUTPUT_FILE"
  echo "--------------" >> "$OUTPUT_FILE"
  cat /etc/passwd >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
}

# Add more functions for specific checks as needed

# Main function
main() {
  log_system_info
  log_user_accounts
  # Add more function calls for additional checks

  echo "Audit completed. Results saved to $OUTPUT_FILE"
}

# Run the script
main
