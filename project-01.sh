#!/bin/bash
# Author: Spider
# Purpose: System Health Monitor
# Covers: functions, logging, error handling, command output parsing

log_file="health_monitor.log"

# ---------- Logging function ----------
log() {
    local level=$1
    local message=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] - $message" | tee -a "$log_file"
}

# ---------- Uptime ----------
check_uptime() {
    echo "----- Uptime -----"
    uptime
}

# ---------- CPU Usage ----------
check_cpu() {
    echo "----- CPU Usage -----"
    top -bn1 | grep "Cpu(s)"
}

# ---------- RAM Usage ----------
check_ram() {
    echo "----- RAM Usage -----"
    free -h
}

# ---------- Disk Usage ----------
check_disk() {
    echo "----- Disk Usage -----"
    df -h --total | grep total
}

# ---------- Running Services ----------
check_services() {
    echo "----- Running Services (Top 5) -----"
    systemctl list-units --type=service --state=running --no-pager | head -5
}

# ---------- Network Connectivity ----------
check_network() {
    echo "----- Network Connectivity -----"
    target="8.8.8.8"
    ping -c 2 "$target" > /dev/null 2>&1

    if [ $? -eq 0 ]
    then
        log "INFO" "Network is UP (ping to $target successful)"
    else
        log "ERROR" "Network is DOWN (ping to $target failed)"
    fi
}

# ---------- Main script ----------
log "INFO" "Health check started"

check_uptime
check_cpu
check_ram
check_disk
check_services
check_network

log "INFO" "Health check completed"
