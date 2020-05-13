#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})

declare -ar VSCODE_EXTENSIONS=(\
    "alefragnani.Bookmarks" \
    "ms-vscode.cpptools" \
    "platformio.platformio-ide" \
    "stkb.rewrap" \
    "streetsidesoftware.code-spell-checker" \
    "vscodevim.vim" \
    "ms-vscode.cmake-tools" \
    "twxs.cmake" \
)

echo "==> Installing Codium prerequisites"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    libasound2

echo "==> Set up Codium repository"
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add - 
echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list 

echo "==> Updating list of repositories"
sudo apt -y update

echo "==> Installing Codium"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    codium

echo "==> Installing Codium extensions"
for extension in "${VSCODE_EXTENSIONS[@]}"
do
    codium --install-extension "${extension}"
done

echo "==> Copying configuration"
cp -a /tmp/files/config/codium/. ~
