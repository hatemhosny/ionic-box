#!/usr/bin/env bash

# Android properties
ANDROID_SDK_TOOLS_VERSION=26.6.2
ANDROID_SDK_TOOLS_FILENAME=tools_r$ANDROID_SDK_TOOLS_VERSION-linux.zip
ANDROID_SDK_TOOLS=https://dl.google.com/android/repository/tools_r$ANDROID_SDK_TOOLS_VERSION-linux.zip

#Node properties
NODE_VERSION=6.10.2
NODE_FILENAME=node-v$NODE_VERSION-linux-x64.tar.gz
NODE_DOWNLOAD=https://nodejs.org/download/release/latest-boron/$NODE_FILENAME
# YARN package
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# packages
PACKAGE_LIST=(
#    build-essential
#    tcl
    unzip
#    python-software-properties
    make
#    git
    default-jdk
    ant
    expect
    yarn
)
echo "---clearing previous logs---"
[ -e /vagrant/vm_build.log ] && rm /vagrant/vm_build.log
echo "---updating and installing packages---"
#build essentials.
apt-get update >> /dev/null 2>&1

# install all required packages
apt-get install -y ${PACKAGE_LIST[@]} >> /vagrant/vm_build.log 2>&1

echo "---installing Android SDK---"
(cd /tmp; curl -sSO $ANDROID_SDK_TOOLS >> /vagrant/vm_build.log 2>&1)
(cd /tmp; unzip -q $ANDROID_SDK_TOOLS_FILENAME -d /home/vagrant/android-sdk/)
chown -R ubuntu /home/vagrant/android-sdk/
echo "---setting path variables---"
echo "ANDROID_HOME=/home/vagrant/android-sdk" >> /home/vagrant/.bashrc
echo "PATH=\$PATH:/home/vagrant/android-sdk/tools:/home/vagrant/android-sdk/platform-tools" >> /home/vagrant/.bashrc
expect -c '
set timeout -1   ;
spawn /home/vagrant/android-sdk/tools/bin/sdkmanager "platforms;android-25" "build-tools;25.0.2" "platform-tools"
expect { 
    "Accept? (y/N):" { exp_send "y\r" ; exp_continue }
    eof
}
' >> /vagrant/vm_build.log 2>&1

echo "---installing nodejs---"
mkdir /home/vagrant/nodejs
(cd /tmp; curl -sSO $NODE_DOWNLOAD >> /vagrant/vm_build.log 2>&1)
(cd /tmp; tar -C /home/vagrant/nodejs/ --strip-components 1 -xzf $NODE_FILENAME)
echo "PATH=\$PATH:/home/vagrant/nodejs/bin" >> /home/vagrant/.bashrc

echo "---installing nativescript and typescript globally---"
export PATH=\$PATH:/home/vagrant/nodejs/bin
yarn global add nativescript typescript >> /vagrant/vm_build.log 2>&1
chown -R ubuntu /home/vagrant/nodejs
echo '---machine provisioned---'

echo "---installing advanced angular seed dependencies---"
(cd /vagrant; yarn install >> /vagrant/vm_build.log 2>&1)
echo '---advanced angular seed dependencies installed---'
