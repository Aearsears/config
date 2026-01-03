# --- Start SSH agent safely (handles spaces in username) ---
SSH_ENV="$HOME/.ssh/agent-env"

# Function to start a new agent
start_agent() {
    OUTPUT=$(ssh-agent -s)
    SOCK=$(echo "$OUTPUT" | grep SSH_AUTH_SOCK | cut -d'=' -f2 | cut -d';' -f1)
    PID=$(echo "$OUTPUT" | grep SSH_AGENT_PID | cut -d'=' -f2 | cut -d';' -f1)
    
    echo "export SSH_AUTH_SOCK=\"$SOCK\"" > "$SSH_ENV"
    echo "export SSH_AGENT_PID=\"$PID\"" >> "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    
    export SSH_AUTH_SOCK="$SOCK"
    export SSH_AGENT_PID="$PID"
}

# Check if the env file exists and source it
if [ -f "$SSH_ENV" ]; then
    source "$SSH_ENV"
fi

# Check if agent is actually running
if [ -z "$SSH_AGENT_PID" ] || ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
    start_agent
fi

# Add your key automatically (quote path!)
KEY=""
if [ -f "$KEY" ]; then
    FINGERPRINT=$(ssh-keygen -lf "$KEY" 2>/dev/null | awk '{print $2}')
    ssh-add -l 2>/dev/null | grep -q "$FINGERPRINT" || ssh-add "$KEY" 2>/dev/null
fi
# ------------------------------------------------------------