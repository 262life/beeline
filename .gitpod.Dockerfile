FROM gitpod/workspace-full

# Install custom tools, runtime, etc.
RUN sudo apt install -y shellcheck \
&& curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && sudo mv kubectl /usr/local/bin/kubectl && sudo chmod 755 /usr/local/bin/kubectl \
    && sudo apt install -y xdg-utils \
    && curl https://get.okteto.com -sSfL | sh \
    && sudo rm -rf /var/lib/apt/lists/* 

# Apply user-specific settings




