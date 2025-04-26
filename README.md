# IP Filter & Blacklist Checker

![GitHub](https://img.shields.io/badge/license-MIT-blue)

A bash script to check if your server's IP is:
- Filtered/blocked in Iran (via ArvanCloud API)
- Blacklisted globally (via HetrixTools API)

## Features
- ✅ Quick IP filtering check for Iran
- ✅ Global blacklist monitoring
- ✅ Clear visual status indicators
- ✅ Detailed error logging

## Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ip-checker.git
   cd ip-checker

2. Make the script executable:
   ```bash
   chmod +x ip_checker.sh

3. Edit the script to add your HetrixTools API key:
   ```bash
   nano ip_checker.sh

4. Run the script:
   ```bash
   ./ip_checker.sh

## Requirements
● curl - For API requests
● bash - Shell environment

## API Keys
● Get HetrixTools API key from: https://hetrixtools.com/dashboard/
