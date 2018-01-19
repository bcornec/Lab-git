# Lab Environment Overview

This document purpose is to acquaint you with the environment used by the lab sessions.

## Objectives

To describe the setup needed for the lab which could be run locally or on a remote environment, including the network, the deployment server, infrastructure services, and details about the student systems.

## Lab instructions
You can find the Lab contents at https://github.com/bcornec/Labs 
You'll be able to start following the instructions there once you're done with the setup, either local or using a remote facility.

## Local Installation

Please prepare your environment (laptop or server available or cloud based access) going the following tasks:

Install 1 Linux VMs corresponding to 2 vCPU/2GB using a recent 64 bits Linux distribution (typically CentOS 7, Ubuntu 16.04, Fedora 26, ...). 

You can use your preferred hypervisor locally (VirtualBox, VMware workstation, vSPhere...) or your preferred Cloud provider (Azure, Rackspace, Digital Ocean, Amazon...) or if you're richer, your preferred hardware servers ! 

You need to configure the network in order for the VMs to have Internet access (using a potential proxy if needed as on the HPE network).

## Remote Lab Usage

If you have access to the remote Lab (your instructor will tell you) then you need to do the following setup phase to be ready to use it.

### Network setup

The lab network uses HPE Servers (Moonshot cartridges or ProLiant Blades, or OpenSTack VMs), located in the HPE Customer Innovation Center in Geneva, Switzerland and reached through a dedicated VPN.  You need to activate that VPN by launching on Linux the following commands:


`$` **`mkdir -p ~/lab`**

`$` **`cd ~/lab`**

`$` **`wget ftp://ftp.hpintelco.net/pub/openvpn/ca.crt`**

`$` **`wget ftp://ftp.hpintelco.net/pub/openvpn/labFLOSSCon.key`**

`$` **`wget ftp://ftp.hpintelco.net/pub/openvpn/labFLOSSCon.crt`**

`$` **`wget ftp://ftp.hpintelco.net/pub/openvpn/vpnlabFLOSSCon.conf`**

`$` **`sudo openvpn --config vpnlabFLOSSCon.conf`**


For those of you unlucky using a Windows desktop system, then install first wget from http://labossi.hpintelco.net/win/wget.exe or http://labossi.hpintelco.net/win/wget64.exe and then openvpn in case you don't have it from http://openvpn.net/index.php/open-source/downloads.html (internal mirror at http://labossi.hpintelco.net/win/) 

You need to launch a cmd command as **Administrator** on your system (use the Start/windows button, type cmd and right click on the icon appearing to select Run as Administrator) and then you have to run in it 

`C:\WINDOWS\SYSTEM32>` **`md C:\openvpn`**

`C:\WINDOWS\SYSTEM32>` **`cd C:\openvpn`**

Download the 4 files previously mentioned in the wget command under C:\openvpn. Then issue:

`C:\openvpn>` **`openvpn --config vpnlabFLOSSCon.conf`**

From now on, you should be able to connect using ssh to your system. If you're making this lab from within the HPE Network, you'll need to edit the vpnlabFLOSSCon.conf file to enable the appropriate proxy.

For those of you still unlucky using a Windows desktop system, then install putty in case you don't have it from http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html (internal mirror at http://labossi.hpintelco.net/win/putty-0.67-installer.msi) then launch putty in the run command interface and log on your target system.

For those of you unlucky using a MacOS desktop system, then install a compatible openvpn tool in case you don't have it already from https://code.google.com/p/tunnelblick/. Then launch TunnelBlick using that conf file.

![Tunnelblick bar ](/img/tb1.png)https://github.com/bcornec/Labs
![Tunnelblick configuration ](/img/tb2.png)

### Operating system setup

All systems have been deployed before the Lab with a CentOS 7 Linux distribution. 

In case you need additional tools on the system, you can search for a package (*yum search pattern*)  and then install it from the deployment server (*yum install package*).

Each student group should receive a Lab number (X) from the instructor or find it written on the table.

All student servers named cX or labX (where X is the previously mentioned number) receive their fixed-assigned addresses using a DHCP server. 

In case you encounter issues with name resolution (typically with a Windows client) then here is the mapping of names and IP addresses:

| Name of physical nodes | IP |
| --- | --- |
| c6 | 10.11.51.136 |
| c7 | 10.11.51.137 |
| c8 | 10.11.51.138 |
| c9 | 10.11.51.139 |
| c10 | 10.11.51.140 |
| c11 | 10.11.51.141 |
| c12 | 10.11.51.142 |
| c13 | 10.11.51.143 |
| c14 | 10.11.51.144 |
| c15 | 10.11.51.145 |

Root access is available using the **linux1** password.

| Name of virtual nodes | IP |
| --- | --- |
| lab1 | 10.11.53.101 |
| lab2 | 10.11.53.102 |
| lab3 | 10.11.53.103 |
| lab4 | 10.11.53.104 |
| ...  | ... |
| lab10 | 10.11.53.110 |
| ...  | ... |
| lab19 | 10.11.53.119 |
| lab20 | 10.11.53.120 |

Root access is available using the **FLOSSCon2018** password. (There is a centos account with the password FLOSSCon for non-root activities, in fact nearly all ;-)

## Instructor notes

In order to create a new access for a Lab, you need to follow the following receipe on the VPN server:

```
cd /etc/openvpn/easy-rsa/
. ./vars
./build-key labXXX
perl -p -e 's/lab2017/labXXX/g' keys/vpnlab2017.conf > keys/vpnlabXXX.conf
perl -pi -e 's/vpn.innovationcenters/labossi.hpintelco/' keys/vpnlabXXX.conf
chown bruno keys/*labXXX*
```
Then on the management node
```
cd prj/perso/labossi/keys/
scp -p gvadeploy:/etc/openvpn/easy-rsa/keys/'*labXXX*' .
rm *.csr
scp -p *labXXX* ftphpisc:~ftp/pub/openvpn/
ssh ftphpisc "cd ~ftp/pub/openvpn ; chmod 644 *labXXX*"
```
