#!/bin/bash


sudo apt-get install -y curl software-properties-common apt-transport-https wget

# Installing Java 22
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo apt-key add -
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update
sudo apt install -y temurin-22-jdk

# Prompt message
echo "We are detecting if Node Version Manager (NVM) is installed on your system."

# Check if NVM is installed
if command -v nvm &> /dev/null; then
    echo "Node Version Manager (NVM) found on your system."
    echo "We are about to remove NVM from your system. As it can cause a conflict with our Node.js installation."
    echo "Please note that this will remove NVM and all its installed versions of Node.js."
    echo "We are going to install npm install -g n instead of nvm."
    echo "If you are not agree with this, please type 'no' to cancel the operation."
    
    # Ask for confirmation
    read -p "If you agree, type 'yes' to continue: " confirmation

    # Check user confirmation
    if [ "$confirmation" == "yes" ]; then
        echo "Proceeding with removal..."
        ## REMOVING NVM AS IT CAN CAUSE A CONFLICT
        sudo rm -rf "$HOME/.nvm"
        sudo rm -rf "$HOME/nvm"
        sudo rm -rf ~/nvm
        sudo rm -rf ~/.nvm
        # For CodeSpace
        sudo rm -rf /home/codespace/nvm/current/bin/node
        sudo rm -rf /home/"$HOME"/nvm/current/bin/node
        sudo rm -rf /home/codespace/nvm
        sudo rm -rf /home/"$HOME"/nvm
        sudo rm -rf /home/codespace/.nvm
        sudo rm -rf /home/"$HOME"/.nvm
    else
        echo "Cancellation requested. Exiting without making changes."
        exit 1
    fi
else
    echo "Node Version Manager (NVM) is not installed on your system."
    echo "Nothing to remove."
fi

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs


sudo npm install -g n


sudo n lts

# sudo n latest
# sudo n 16.13.0


#sudo npm cache clean -f
#sudo n prune


node --version
npm --version

