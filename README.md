# macOS Network Tools & AI Remote Access

A collection of scripts and configurations to maintain a clean network environment on macOS and enable secure remote access to local AI services.

## 🛠 Features
- **Network Fixer:** An AppleScript tool to flush routing tables, clear DNS caches, and terminate ghost VPN processes (NordVPN, Surfshark, etc.).
- **Remote Ollama Gateway:** Configuration guide to expose Ollama to a private **Tailscale** network, bypassing the default `localhost` restriction.
- **DNS Auto-Restoration:** Logic to restore local DNS (FRITZ!Box) to ensure ad-blocking remains active after VPN sessions.

---

## 🚀 Getting Started
1. Network Repair Tool

To use the repair script, save the following logic as an .app via the macOS Script Editor:

```applescript

-- Force quit stuck VPN daemons
do shell script "sudo killall -9 NordVPN 'NordVPN Helix' Surfshark Tunnelblick" with administrator privileges

-- Reset routing and DNS
do shell script "sudo route -n flush" with administrator privileges
do shell script "networksetup -setdnsservers Wi-Fi Empty" with administrator privileges
```

2. Exposing Ollama to Tailscale
   To access your Mac's LLMs from a remote VPS:
   1. Set the Host Variable:
   ```Bash
      launchctl setenv OLLAMA_HOST "0.0.0.0"
   ```
   2. Restart Ollama and verify the binding:
   ```Bash
      netstat -an | grep 11434
   ```
   Target output: *.11434 or 0.0.0.0.11434

--- 

## 🔧 Prerequisites

Hardware: 
- Mac with Apple Silicon (M1 or newer).
- OS: macOS 15+ (Sequoia / Tahoe).
- Networking: Tailscale installed for secure mesh-VPN connectivity.

---

📝 Background
This project was born out of the necessity to manage a complex hybrid network stack (Work VPNs vs. Private Meshnets) without losing access to local infrastructure and AI services.

⚖️ License
Distributed under the MIT License. See LICENSE for more information.
