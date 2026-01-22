-- macOS Network-Fix & VPN Cleanup Tool
-- Purpose: Resolves routing conflicts and DNS issues caused by multiple VPN clients.
-- Supports: NordVPN, Surfshark, Tunnelblick, Cisco AnyConnect, and Tailscale.

display dialog "Starting Network Repair..." buttons {"Cancel", "OK"} default button "OK" with icon note

try
    -- 1. Force quit stuck VPN processes to release virtual network interfaces (utun)
    -- Using 'killall -9' ensures that even non-responsive daemons are terminated.
    do shell script "sudo killall -9 'NordVPN' 'NordVPN Helix' 'Surfshark' 'Tunnelblick' 'Cisco AnyConnect Secure Mobility Client' 'Tailscale' || true" with administrator privileges

    -- 2. Flush the system routing table
    -- Repeating the flush ensures that all stale routes from previous VPN sessions are cleared.
    repeat 3 times
        do shell script "sudo route -n flush" with administrator privileges
    end repeat

    -- 3. Clear DNS cache
    -- Essential for macOS Sequoia/Tahoe to resolve hostnames correctly after a network change.
    do shell script "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder" with administrator privileges

    -- 4. Reset DNS settings to default (Empty)
    -- This forces macOS to use the DHCP-assigned DNS from your local gateway (e.g., FRITZ!Box).
    do shell script "networksetup -setdnsservers Wi-Fi Empty" with administrator privileges

    -- 5. Toggle Wi-Fi power to refresh the hardware connection
    -- Provides a clean slate for the Wi-Fi interface (en0).
    do shell script "networksetup -setairportpower en0 off" with administrator privileges
    delay 2
    do shell script "networksetup -setairportpower en0 on" with administrator privileges

    display notification "Network repaired and DNS restored to default." with title "Network-Fix"

on error error_message
    display dialog "An error occurred during repair: " & error_message buttons {"OK"} default button "OK" with icon stop
end try
