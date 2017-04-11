Ionic Box (x64)
=============================
### *this is the 64 bit version of ionic-box using ubuntu/xenial64*
Ionic Box is a ready-to-go hybrid development environment for building mobile apps with Ionic, Cordova, and Android. Ionic Box was built to make it easier for developers to build Android versions of their app, and especially for Windows users to get a complete dev environment set up without all the headaches.

For iOS developers, Ionic Box won't do much for you right now unless you are having trouble installing the Android SDK, and Ionic Box cannot be used for iOS development for a variety of legal reasons (however, the `ionic package` command in beta will soon fix that).

### Features
 - Includes [Yarn](https://yarnpkg.com/en/) package manager.
 - x64 bit.
 - Latest Node LTS(6.10.2).
 - Gennymotion support.
 - Android SDK(API-25) and tools included(26.2.2).
 - OpenJDK8
### Installation


To install, download and install [Vagrant](https://www.vagrantup.com/downloads.html) for your platform, then download and install [VirtualBox](http://virtualbox.org/).

Once Vagrant and VirtualBox are installed, you can download the latest release of this GitHub repo, and unzip it. `cd` into the unzipped folder and run:

```bash
$ vagrant up
$ vagrant ssh
```

The username for vagrant is `vagrant` and the password is `vagrant`. 

This will download and install the image, and then go through the dependencies and install them one by one. `vagrant ssh` will connect you to the image and give you a bash prompt. Once everything completes, you'll have a working box to build your apps on Android.

*It exposes ionic-projects folder to root of this directory on HOST machine and /home/vagrant/ionic-projects on vagrant*

### Getting started
```
# inside vagrant ssh session
cd ionic-projects
ionic start --v2 myApp tabs
```
### Connected Android Devices

The image also has support for connected USB Android devices. To test whether devices are connected, you can run (from the box):

```bash
$ sudo /home/vagrant/android-sdk/platform-tools/adb devices
```

If that does not work, or shows `????? permissions`, then run:

```bash
sudo /home/vagrant/android-sdk/platform-tools/adb kill-server
sudo /home/vagrant/android-sdk/platform-tools/adb start-server
```

### Connect Gennymotion
You can connect genymotion by running
```
adb connect <IP of GenyDevice>
```

If you get the error as
```
List of devices attached
<IP of GenyDevice>    offline
```
This sometimes happens because Genymotion while booting up connects the Virtual Device to the HOST's ADB in that case.

__on host machine run__
```
<path to genymotion adb or host adb>/adb tcpip 5556
adb kill-server
````
__then on vagrant machine run__
```
adb connect <IP of GenyDevice>:5556
```
It will fix the error and will appear as, and is ready for go.
```
List of devices attached
<IP of GenyDevice>:5556    device
```

### Useful information.
*You can change the following defaults in vagrantfile*

 - IP: 172.30.1.5
 - user: vagrant
 - password: vagrant
 - shared directory: ionic-projects (nfs:true)
 - vb.cpus: 2
 - vb.memory: 2048

 *android-sdk and nodejs directories are chown'ed by vagrant so sudo is not required, when runnning commands.*

 __If you encounter slow network(internet download) speed on vagrant uncomment the following lines in Vagrantfile.__
 ```
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--nictype1", "Am79C973"] 
```