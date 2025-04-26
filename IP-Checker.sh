#!/bin/bash

# ==============================================
# IP Filter & Blacklist Checker Tool
# ==============================================
# Description: A bash script to check if your server's IP is:
#              1. Filtered/blocked in Iran (via ArvanCloud API)
#              2. Blacklisted globally (via HetrixTools API)
# Author: Amir Nasib Zarrabi
# Repository: https://github.com/yourusername/ip-checker
# License: MIT
# Version: 1.0.0
# ==============================================

# --------------------------
# Configuration
# --------------------------
# HetrixTools API Key (Get yours from: https://hetrixtools.com/dashboard/)
HETRIX_API_KEY="YOUR_HETRIXTOOLS_API_KEY"

# --------------------------
# Global Variables
# --------------------------
declare -A STATUS  # Stores check statuses (✅/❌)
declare -A LOG     # Stores detailed error messages
declare -A IP

# --------------------------
# Functions
# --------------------------

function check_ip_filtering() {
    # Checks if IP is filtered/blocked in Iran using ArvanCloud's IP checker
    echo ">>> Checking IP Filtering / Iran Access <<<"

    # Get server's public IPv4 address
    if [[ -z "$IP" ]]; then
        STATUS[ip_check]="❌"
        LOG[ip_check]="Failed to retrieve server IP."
        return
    fi

    echo "• Detected IP: $IP"
    echo "• Querying ArvanCloud IP Checker API..."

    RESPONSE=$(curl -s --max-time 10 https://napi.arvancloud.com/ipchecker/$IP)

    if echo "$RESPONSE" | grep -qi '"blocked":true'; then
        STATUS[ip_check]="❌"
        LOG[ip_check]="IP appears to be blocked (filtered) in Iran!"
    elif echo "$RESPONSE" | grep -qi '"country":"IR"'; then
        STATUS[ip_check]="❌"
        LOG[ip_check]="IP is recognized as Iranian (Iran Access Enabled)!"
    else
        STATUS[ip_check]="✅"
        LOG[ip_check]="IP is not filtered/blocked in Iran."
    fi
}

function check_hetrixtools() {
    # Checks if IP is blacklisted using HetrixTools API
    echo ">>> Checking IP via HetrixTools <<<"

    if [[ -z "$IP" ]]; then
        STATUS[hetrixtools]="❌"
        LOG[hetrixtools]="Failed to retrieve server IP."
        return
    fi

    echo "• Detected IP: $IP"
    echo "• Querying HetrixTools Blacklist Check API..."

    RESULT=$(curl -s "https://api.hetrixtools.com/v2/$HETRIX_API_KEY/blacklist-check/ipv4/$IP/")

    if echo "$RESULT" | grep -q '"blacklisted_count":0'; then
        STATUS[hetrixtools]="✅"
        LOG[hetrixtools]="IP is clean (not blacklisted)."
    else
        STATUS[hetrixtools]="❌"
        LOG[hetrixtools]="IP is blacklisted according to HetrixTools!"
    fi
}

function show_summary() {
    # Displays a summary of all checks
    echo ""
    echo ">>> IP Check Summary <<<"
    printf "\n%-25s %-8s %s\n" "Check" "Status" "Details"
    printf "%-25s %-8s %s\n" "-------------------------" "--------" "-------------------------"

    for key in "${!STATUS[@]}"; do
        printf "%-25s %-8s %s\n" "$key" "${STATUS[$key]}" "${LOG[$key]}"
    done
}

# --------------------------
# Main Execution
# --------------------------
clear
echo "Starting IP Filter & Blacklist Checks..."
echo "========================================"

IP="$(hostname -I | awk '{print $1}')"

check_ip_filtering
check_hetrixtools
show_summary
