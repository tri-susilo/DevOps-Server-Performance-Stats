#!/bin/bash

# Function to display total CPU usage
display_cpu_usage() {
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | awk '{print "  Used: " $2 "%, Idle: " $8 "%"}'
}

# Function to display total memory usage
display_memory_usage() {
    echo "Memory Usage:"
    free -h | awk '/Mem:/ {
        total=$2; used=$3; free=$4;
        printf "  Total: %s, Used: %s (%.2f%%), Free: %s (%.2f%%)\n", 
        total, used, ($3/$2)*100, free, ($4/$2)*100
    }'
}

# Function to display total disk usage
display_disk_usage() {
    echo "Disk Usage:"
    df -h --total | awk '/total/ {
        printf "  Total: %s, Used: %s (%.2f%%), Free: %s\n", 
        $2, $3, ($3/$2)*100, $4
    }'
}

# Function to display top 5 processes by CPU usage
display_top_cpu_processes() {
    echo "Top 5 Processes by CPU Usage:"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk 'NR==1 {print "  PID   COMMAND   CPU%"} NR>1 {printf "  %-5s %-10s %-5s\n", $1, $2, $3}'
}

# Function to display top 5 processes by memory usage
display_top_memory_processes() {
    echo "Top 5 Processes by Memory Usage:"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk 'NR==1 {print "  PID   COMMAND   MEM%"} NR>1 {printf "  %-5s %-10s %-5s\n", $1, $2, $3}'
}

# Function to display additional stats (stretch goal)
display_additional_stats() {
    echo "Additional Stats:"
    echo "  OS Version: $(lsb_release -d | cut -f2)"
    echo "  Uptime: $(uptime -p)"
    echo "  Load Average: $(uptime | awk -F'load average:' '{print $2}')"
    echo "  Logged-in Users: $(who | wc -l)"
    echo "  Failed Login Attempts: $(grep -c 'Failed password' /var/log/auth.log 2>/dev/null || echo 'Log not found')"
}

# Main function to display all stats
display_stats() {
    echo "================ Server Performance Stats ================"
    display_cpu_usage
    echo
    display_memory_usage
    echo
    display_disk_usage
    echo
    display_top_cpu_processes
    echo
    display_top_memory_processes
    echo
    display_additional_stats
    echo "=========================================================="
}

# Execute the main function
display_stats
