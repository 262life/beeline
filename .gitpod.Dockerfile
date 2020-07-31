FROM gitpod/workspace-full

# Install custom tools, runtime, etc.
RUN sudo apt install -y shellcheck \
    && sudo rm -rf /var/lib/apt/lists/* 

# Apply user-specific settings


