# Docker Lab Contents

The goal of this lab is to install and use Docker to become familiar with Linux based containers and handle some of the common use cases around it. By the end of this lab you will have created a Web application comprised of a number of micro-services.

## Lab Writers and Trainers
  - Bruno.Cornec@hpe.com
  - Rene.Ribaud@hpe.com

Table of Contents
=================

   * [Docker Lab Contents](#docker-lab-contents)
      * [Lab Writers and Trainers](#lab-writers-and-trainers)
      * [Objectives of the Docker Lab](#objectives-of-the-docker-lab)
      * [Reference documents](#reference-documents)
      * [Note on Linux commands](#note-on-linux-commands)
   * [Environment setup](#environment-setup)
      * [Proxy consideration](#proxy-consideration)
      * [Docker installation](#docker-installation)
         * [Ubuntu installation](#ubuntu-installation)
         * [CentOS installation](#centos-installation)
         * [Check installation](#check-installation)
   * [Using Docker](#using-docker)
      * [The first container](#the-first-container)
      * [The second container](#the-second-container)
   * [Configuring owncloud in a container](#configuring-owncloud-in-a-container)
   * [Using Docker compose](#using-docker-compose)
      * [Installing Docker compose](#installing-docker-compose)
      * [Our first docker-compose.yml file](#our-first-docker-composeyml-file)
      * [Going further with docker-compose.yml](#going-further-with-docker-composeyml)
   * [Using docker-machine to create Docker hosts](#using-docker-machine-to-create-docker-hosts)
   * [Using Docker Swarm](#using-docker-swarm)
      * [Installing Docker Swarm](#installing-docker-swarm)
      * [Installing on CentOS 7](#installing-on-centos-7)
      * [Installing the engine in the Cloud](#installing-the-engine-in-the-cloud)
      * [Using Docker Swarm to make our configuration available and scalable](#using-docker-swarm-to-make-our-configuration-available-and-scalable)
         * [CentOS 7](#centos-7)
         * [Ubuntu](#ubuntu)
   * [Deploy a cloud native application.](#deploy-a-cloud-native-application)
      * [Objectives](#objectives)

## Objectives of the Docker Lab
At the end of the Lab students should be able to install Docker, use the CLI to create a new image, a container, launch an application in it, store data, configure the network.

This Lab is intended to be trial and error so that during the session students should understand really what is behind the tool.  Blindly following instructions is not an effective way to learn IMHO. You've been warned ;-)

Expected duration : 120 minutes

## Reference documents
When dealing with the installation and configuration of Docker, the first step  is to check the reference Web site http://docker.io/:

At the start of each section there is an estimate of how long it will take to complete.

## Note on Linux commands

If you are familiar with Linux, you can skip this section. If not please read to understand some commands.

In a number of places, the lab uses the Linux here pattern to create text files, as in the following example,

`#` **`cat > fileToCreate << EOF`**
```none
Text line 1
Text line 2
EOF
```

This command will create the text file `fileToCreate` and populate it with the lines of text that follow up but not including the EOF keyword.

You can display the content of the created file with the command `cat fileToCreate`.

In order to append text to the file, the first `>` can be replaced with `>>`.  

If you prefer, you can edit the files using **vim** or **nano** text editors.

## But I'm a poor lonesome Windows cowboy !

Well in that case, first condolences, then read the fine document made by Michael Mayer at https://github.com/bcornec/Labs/blob/master/Docker/LabOnWindows.md to get help.

# Environment setup
Estimated time: 15 minutes

## Proxy consideration

This lab is usually run in our environment that has a direct access to the Internet. If you want to run this lab on your site behind a corporate proxy, you will have to configure your Linux distribution and Docker to access the Internet via your proxy.

The following instruction are available for a Centos 7 distribution, because instructions on the Docker part are systemd based.


 1. Get the proxy IP and port.
 2. Make sure your host can resolve the proxy address using `nslookup <proxy>`, if not use the proxy IP.
 3. Configure your Linux package manager to go through the proxy by exporting the http_proxy and https_proxy environment variables:

```
export http_proxy=http://<proxy name or ip>:<proxy port>
export https_proxy=http://<proxy name or ip>:<proxy port>
```

 4. Configure Docker daemon to use the proxy as explained by this document: https://docs.docker.com/engine/admin/systemd/#http-proxy (in short add Environment="HTTP_PROXY=http://proxy.example.com:80/" "HTTPS_PROXY=http://proxy.example.com:80/" to your [services] section)
 5. **Set the proxy in each of your Dockerfiles** by adding following text as the 2nd and 3rd line of the Dockerfile.

```
ENV http_proxy <HTTP_PROXY>
ENV https_proxy <HTTP_PROXY>
```


## Docker installation
Docker is available externally from http://docs.docker.com/linux/step_one/ or using your distribution packages, or from github at https://github.com/docker/docker
Version 17.03 is the current stable release. This lab requires at least version 1.7.

Ask to your instructor which Linux distribution will be used for the Lab (Ubuntu or CentOS). Then refer to the corresponding instructions below.

Other distributions should be as easy to deal with once the same packages have been installed using the package manager as they should be available directly (Case of most non-commercial distributions such as Debian, Fedora, Mageia, OpenSUSE, ...). Follow the instructions from https://docs.docker.com/engine/installation/

### Ubuntu installation
If you work on an Ubuntu environment for the Lab, you may want to use apt to do the installation of Docker with all its dependencies. As Ubuntu provides an old version of Docker, we will use a PPA providing a more up to date version:

#### 17.04

`#` **`sudo apt-get update`**

`#` **`sudo apt-get install apt-transport-https ca-certificates curl software-properties-common`**

`#` **`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`**

`#` **`sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu zesty stable"`**

Note: (instead of 17.04 use  $(lsb_release -cs) for another version

`#` **`sudo apt-get update`**

`#` **` sudo apt-get install docker-ce`**

#### 14.04

`#` **`apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9`**

`#` **`echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/Docker.list`**

`#` **`apt-get update`**

`#` **`apt-get install lxc-docker`**
```
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following extra packages will be installed:
  aufs-tools cgroup-lite git git-man liberror-perl patch
Suggested packages:
  btrfs-tools debootstrap lxc rinse git-daemon-run git-daemon-sysvinit git-doc
  git-el git-email git-gui gitk gitweb git-arch git-bzr git-cvs git-mediawiki
  git-svn diffutils-doc
The following NEW packages will be installed:
  aufs-tools cgroup-lite lxc-docker git git-man liberror-perl patch
0 upgraded, 7 newly installed, 0 to remove and 0 not upgraded.
Need to get 7,640 kB of archives.
After this operation, 46.9 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://fr.archive.ubuntu.com/ubuntu/ trusty/universe aufs-tools amd64 1:3.2+20130722-1.1 [92.3 kB]
Get:2 https://get.docker.io/ubuntu/ docker/main lxc-docker-1.7.0 amd64 1.7.0 [4,962 kB]
[...]
Fetched 7,640 kB in 8s (884 kB/s)
Selecting previously unselected package aufs-tools.
(Reading database ... 54255 files and directories currently installed.)
Preparing to unpack .../aufs-tools_1%3a3.2+20130722-1.1_amd64.deb ...
Unpacking aufs-tools (1:3.2+20130722-1.1) ...
[...]
Setting up lxc-docker (1.7.0) ...
Adding group docker' (GID 111) ...
Done.
[...]
```

### Debian installation

Docker is providing deb packages to help you install the Engine on your Debian distribution:

`#` **`wget -O- https://apt.dockerproject.org/gpg | apt-key add -`**

`#` **`echo deb https://apt.dockerproject.org/repo debian-stretch main > /etc/apt/sources.list.d/Docker.list`**

`#` **`apt-get update`**

`#` **`apt-get install docker-engine`**

This procedure should also work for Ubuntu based distributions.

### CentOS installation

If you work on a CentOS 7 environment for the Lab, you may want to use yum to do the installation of Docker with all its dependencies. Add the repo provided by the Docker project (which is requiring 7.2 at least, but not by CentOS if you use that variant):

`#` **`cat > /etc/yum.repos.d/docker.repo << EOF`**
```none
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```

`#` **`yum install docker-engine`**
```none
Loaded plugins: product-id, search-disabled-repos, subscription-manager
This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
Resolving Dependencies
--> Running transaction check
---> Package docker-engine.x86_64 0:1.11.2-1.el7.centos will be installed
--> Processing Dependency: docker-engine-selinux >= 1.11.2-1.el7.centos for package: docker-engine-1.11.2-1.el7.centos.x86_64
--> Processing Dependency: libcgroup for package: docker-engine-1.11.2-1.el7.centos.x86_64
--> Processing Dependency: libltdl.so.7()(64bit) for package: docker-engine-1.11.2-1.el7.centos.x86_64
[...]

============================================================================================================
 Package                        Arch                Version                   Repository               Size
============================================================================================================
Installing:
 docker-engine                  x86_64              1.11.2-1.el7.centos       dockerrepo               13 M
Installing for dependencies:
 audit-libs-python              x86_64              2.4.1-5.el7               base                     69 k
 checkpolicy                    x86_64              2.1.12-6.el7              base                    247 k
 docker-engine-selinux          noarch              1.11.2-1.el7.centos       dockerrepo               28 k
 libcgroup                      x86_64              0.41-8.el7                base                     64 k
 libsemanage-python             x86_64              2.1.10-18.el7             base                     94 k
 libtool-ltdl                   x86_64              2.4.2-20.el7              base                     49 k
 policycoreutils-python         x86_64              2.2.5-20.el7              base                    435 k
 python-IPy                     noarch              0.75-6.el7                base                     32 k
 setools-libs                   x86_64              3.3.7-46.el7              base                    485 k

Transaction Summary
============================================================================================================
Install  1 Package (+9 Dependent packages)

Total download size: 15 M
Installed size: 59 M
Is this ok [y/d/N]: y
Downloading packages:.
[...]
```

`#` **`systemctl start docker`**

### Check installation

Check that the correct version is installed and operational:

`#` **`docker --version`**
```
Docker version 1.11.2, build b9f10c9
```
`#` **`docker info`**
```
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 1.11.2
Storage Driver: devicemapper
 Pool Name: docker-253:2-130978-pool
 Pool Blocksize: 65.54 kB
 Base Device Size: 10.74 GB
 Backing Filesystem: xfs
 Data file: /dev/loop0
 Metadata file: /dev/loop1
 Data Space Used: 11.8 MB
 Data Space Total: 107.4 GB
[...]
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: null host bridge
Kernel Version: 3.10.0-327.el7.x86_64
Operating System: Red Hat Enterprise Linux Server 7.2 (Maipo)
OSType: linux
Architecture: x86_64
CPUs: 6
Total Memory: 15.39 GiB
Name: lab3.labossi.hpintelco.org
ID: JFU6:LTUL:UOB2:4NEE:IZFC:FZK7:INUC:7ABM:JRVG:NQOS:VSXH:4XMG
Docker Root Dir: /var/lib/docker
Debug mode (client): false
Debug mode (server): false
Registry: https://index.docker.io/v1/
WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
```
`#` **`docker `**

[Display online help]

Now that the software has been installed, we'll use it to create and manage containers.

# Using Docker
Estimated time: 15 minutes.
## The first container
In order to be able to manage a first container, the easiest approach is to import an existing one, before creating your own. For that we will refer to the public Docker registry which contains thousands of ready to be consumed containers:

`#` **`docker run hello-world`**
```
Unable to find image 'hello-world:latest' locally
latest: Pulling from hello-world
a8219747be10: Pull complete
91c95931e552: Already exists
hello-world:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.
Digest: sha256:aa03e5d0d5553b4c3473e89c8619cf79df368babd18681cf5daeb82aab55838d
Status: Downloaded newer image for hello-world:latest
Hello from Docker.
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (Assuming it was not already locally available.)
 3. The Docker daemon created a new container from that image which runs
    the executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

For more examples and ideas, visit:
 http://docs.docker.com/userguide/
```

So we've got a success! Of course, we do not really go far, but what can you expect from an hello-world example ;-) 

However, we can get some info on our modified Docker environment:

`#` **`docker images`**
```
REPOSITORY     TAG            IMAGE ID       CREATED          VIRTUAL SIZE
hello-world    latest         91c95931e552   10 weeks ago     910 B
```
`#` **`docker ps -a`**
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
4dba332aec93d        hello-world         "/hello"            14 minutes ago      Exited (0) 14 minutes ago                       cocky_hopper
```
`#` **`docker rm 4dba332aec93d`**
```
dba332aec93d
```
`#` **`docker ps -a`**
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
`#` **`docker images`**
```
REPOSITORY     TAG            IMAGE ID       CREATED          VIRTUAL SIZE
hello-world    latest         91c95931e552   10 weeks ago     910 B
```

So we see that we now have an image which has been downloaded from the Docker public registry, and that a container has been instantiated from that image and is not running anymore. The `rm` command allows to delete the container (but of course not the image which remains available)
## The second container
In order to have a more interesting environment, we'll now look for existing container images in the public Docker registry, and choose to use a fedora image on our host environment:

`#` **`docker search fedora`**
```
NAME         DESCRIPTION                    STARS    OFFICIAL  AUTOMATED
fedora       Official Fedora 22 base image  175      [OK]
tutum/fedora Fedora image with SSH access.  7                  [OK]
[...]
```
`#` **`docker pull fedora`**
```
latest: Pulling from fedora
48ecf305d2cf: Pull complete
ded7cd95e059: Already exists
fedora:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.
Digest: sha256:10ba981a70632d7764c21deae25c6521db6d39730e1dd8caff90719013858a7b
Status: Downloaded newer image for fedora:latest
```

Once the container image has been downloaded we can view it in our catalog of images:

`#` **`docker images`**
```
REPOSITORY    TAG        IMAGE ID          CREATED            VIRTUAL SIZE
fedora        latest     ded7cd95e059      4 weeks ago        186.5 MB
hello-world   latest     91c95931e552      10 weeks ago       910 B
```

This content is called an image and will serve as the base to create the operational container (here based on Fedora) in which we will process data:

`#` **`docker run -ti ded7cd95e059 /bin/bash`**

`[root@ad9b474525d0 /]#` **`cat /etc/fedora-release`**
```
Fedora release 22 (Twenty Two)
```
`[root@ad9b474525d0 /]#` **`yum install -y wget`**
```
Yum command has been deprecated, redirecting to '/usr/bin/dnf install wget'.
[...]
Fedora 22 - x86_64                             3.7 MB/s |  41 MB     00:11
Fedora 22 - x86_64 - Updates                   1.7 MB/s | 9.7 MB     00:05
Last metadata expiration check performed 0:00:04 ago on Tue Jun 30 10:38:14 2015.
Dependencies resolved.
==========================================================================
 Package               Arch   Version        Repository               Size
==========================================================================
Installing:
 libicu                x86_64 54.1-1.fc22    fedora                  8.4 M
 libpsl                x86_64 0.7.0-3.fc22   fedora                   50 k
 wget                  x86_64 1.16.3-1.fc22  fedora                  577 k

Transaction Summary
==========================================================================
Install  3 Packages

Total download size: 9.0 M
Installed size: 31 M
Downloading Packages:
(1/3): libpsl-0.7.0-3.fc22.x86_64.rpm           16 kB/s |  50 kB     00:03
(2/3): wget-1.16.3-1.fc22.x86_64.rpm           176 kB/s | 577 kB     00:03
(3/3): libicu-54.1-1.fc22.x86_64.rpm           1.8 MB/s | 8.4 MB     00:04
--------------------------------------------------------------------------
Total                                                                                                                     1.4 MB/s | 9.0 MB     00:06
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Installing  : libicu-54.1-1.fc22.x86_64                              1/3
warning: Unable to get systemd shutdown inhibition lock
  Installing  : libpsl-0.7.0-3.fc22.x86_64                             2/3
  Installing  : wget-1.16.3-1.fc22.x86_64                              3/3
  Verifying   : wget-1.16.3-1.fc22.x86_64                              1/3
  Verifying   : libpsl-0.7.0-3.fc22.x86_64                             2/3
  Verifying   : libicu-54.1-1.fc22.x86_64                              3/3

Installed:
  libicu.x86_64 54.1-1.fc22 libpsl.x86_64 0.7.0-3.fc22 wget.x86_64 1.16.3-1.fc22

Complete!

```
`[root@ad9b474525d0 /]#` **`uname -a`**
```
Linux ad9b474525d0 3.16.0-41-generic #57~14.04.1-Ubuntu SMP Thu Jun 18 18:01:13 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
```
If you're on a CentOS distribution it will rather be:
```
Linux ad9b474525d0 3.10.0-327.el7.x86_64 #1 SMP Thu Oct 29 17:29:29 EDT 2015 x86_64 x86_64 x86_64 GNU/Linux
```


So you checked that your container behaves like a Fedora 22 distribution. Only the kernel is shared between the Docker host and the Docker container. Open another console to view how this container has been created ans is seen:

`#` **`docker ps`**
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
ad9b474525d0        ded7cd95e059        "/bin/bash"         12 minutes ago      Up 12 minutes                           hopeful_hopper
```
If you logout of the container, you'll see how Docker manages that fact:

`[root@ad9b474525d0 /]#` **`exit`**

`#` **`docker ps`**
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
`#` **`docker ps -a`**
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
ad9b474525d0        ded7cd95e059        "/bin/bash"         23 minutes ago      Exited (0) 4 seconds ago                       hopeful_hopper
```

So your container is seen as stopped and you have to use the -a option to see it in the history of containers created, but not active anymore.

Re-create a new container based on the same image, connect to it and look at the packages installed. Check what Docker sees. Use the previous commands to perform these tasks.

Answer the questions:
  1. Can you download a web page with wget in your container ? Why ? Which steps are needed now ? Why ?
  2. Can you connect back to your first container ? (Hint: use **docker start** to re-enable your dead container and **docker attach** to re-enter in it)
  3. Feel free to call the trainer if something is unclear or if you want to ensure you understand all points.

# Configuring owncloud in a container

Estimated time: 60 minutes.

Based on the work done in the Docker Dojo during a Grenoble Docker Meetup (cf: https://github.com/Enalean/docker-dojo/tree/master/owncloud).

Owncloud is a web based application providing services such as calendar data or file sharing e.g.
When we want to contain an application such as owncloud, there are a certain number of aspects to take in account and solve:
  1. installing the application and its dependencies in the container
  2. allow IP configuration for remote access to the application
  3. allow data persistence at each invocation of the container
  4. allow configuration data persistence at each invocation of the container
One possibility would be to run the container from an image and launch the various commands in the container (as we've done previously). We could put that in a script and launch it systematically when we instantiate a container from an image, or rebuild a prepared image to be instantiated later. But there is a better way to achieve what we want to do, and this is by using the automation process by Docker with the Dockerfile.

The Dockerfile is a way to describe all the operations required to create an image from an initial empty one and stacking all the operations to build at the end the final image ready to be instantiated and consumed and thrown away
Let's start our Dockerfile by creating a simple container from a base image and just installing some software components useful for our environment, and build an image from that:

`#` **`cat > Dockerfile << EOF`**
```
FROM centos:6
RUN yum install -y httpd
EOF
```
`#` **`docker build .`**
```
Sending build context to Docker daemon  12.8 kB
Sending build context to Docker daemon
Step 0 : FROM centos:6
 ---> a005304e4e74
Step 1 : RUN yum install -y httpd
 ---> Running in ec382fdf21bb
Loaded plugins: fastestmirror
Setting up Install Process
Resolving Dependencies
--> Running transaction check
---> Package httpd.x86_64 0:2.2.15-39.el6.centos will be installed
--> Processing Dependency: httpd-tools = 2.2.15-39.el6.centos for package: httpd-2.2.15-39.el6.centos.x86_64
--> Processing Dependency: system-logos >= 7.92.1-1 for package: httpd-2.2.15-39.el6.centos.x86_64
--> Processing Dependency: apr-util-ldap for package: httpd-2.2.15-39.el6.centos.x86_64
--> Processing Dependency: /etc/mime.types for package: httpd-2.2.15-39.el6.centos.x86_64
--> Processing Dependency: libaprutil-1.so.0()(64bit) for package: httpd-2.2.15-39.el6.centos.x86_64
--> Processing Dependency: libapr-1.so.0()(64bit) for package: httpd-2.2.15-39.el6.centos.x86_64
--> Running transaction check
---> Package apr.x86_64 0:1.3.9-5.el6_2 will be installed
---> Package apr-util.x86_64 0:1.3.9-3.el6_0.1 will be installed
---> Package apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1 will be installed
---> Package httpd-tools.x86_64 0:2.2.15-39.el6.centos will be installed
---> Package mailcap.noarch 0:2.1.31-2.el6 will be installed
---> Package redhat-logos.noarch 0:60.0.14-12.el6.centos will be installed
--> Finished Dependency Resolution

Dependencies Resolved

==========================================================================
 Package             Arch         Version                 Repository  Size
==========================================================================
Installing:
 httpd               x86_64       2.2.15-39.el6.centos    base       825 k
Installing for dependencies:
 apr                 x86_64       1.3.9-5.el6_2           base       123 k
 apr-util            x86_64       1.3.9-3.el6_0.1         base        87 k
 apr-util-ldap       x86_64       1.3.9-3.el6_0.1         base        15 k
 httpd-tools         x86_64       2.2.15-39.el6.centos    base        75 k
 mailcap             noarch       2.1.31-2.el6            base        27 k
 redhat-logos        noarch       60.0.14-12.el6.centos   base        15 M

Transaction Summary
==========================================================================
Install       7 Package(s)

Total download size: 16 M
Installed size: 19 M
Downloading Packages:
--------------------------------------------------------------------------
Total                                           1.0 MB/s |  16 MB     00:15
warning: rpmts_HdrFromFdno: Header V3 RSA/SHA1 Signature, key ID c105b9de: NOKEY
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
Importing GPG key 0xC105B9DE:
 Userid : CentOS-6 Key (CentOS 6 Official Signing Key) <centos-6-key@centos.org>
 Package: centos-release-6-6.el6.centos.12.2.x86_64 (@CentOS/$releasever)
 From   : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
Warning: RPMDB altered outside of yum.
  Installing : apr-1.3.9-5.el6_2.x86_64                                1/7
  Installing : apr-util-1.3.9-3.el6_0.1.x86_64                         2/7
  Installing : httpd-tools-2.2.15-39.el6.centos.x86_64                 3/7
  Installing : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                    4/7
  Installing : mailcap-2.1.31-2.el6.noarch                             5/7
  Installing : redhat-logos-60.0.14-12.el6.centos.noarch               6/7
  Installing : httpd-2.2.15-39.el6.centos.x86_64                       7/7
  Verifying  : httpd-2.2.15-39.el6.centos.x86_64                       1/7
  Verifying  : httpd-tools-2.2.15-39.el6.centos.x86_64                 2/7
  Verifying  : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                    3/7
  Verifying  : apr-1.3.9-5.el6_2.x86_64                                4/7
  Verifying  : redhat-logos-60.0.14-12.el6.centos.noarch               5/7
  Verifying  : mailcap-2.1.31-2.el6.noarch                             6/7
  Verifying  : apr-util-1.3.9-3.el6_0.1.x86_64                         7/7

Installed:
  httpd.x86_64 0:2.2.15-39.el6.centos

Dependency Installed:
  apr.x86_64 0:1.3.9-5.el6_2
  apr-util.x86_64 0:1.3.9-3.el6_0.1
  apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1
  httpd-tools.x86_64 0:2.2.15-39.el6.centos
  mailcap.noarch 0:2.1.31-2.el6
  redhat-logos.noarch 0:60.0.14-12.el6.centos

Complete!
 ---> 358657a2b6b0
Removing intermediate container ec382fdf21bb
Successfully built 358657a2b6b0
```
`#` **`docker images`**
```
REPOSITORY        TAG       IMAGE ID         CREATED          VIRTUAL SIZE
<none>            <none>    358657a2b6b0     3 minutes ago    274.8 MB
centos            6         a005304e4e74     12 days ago      203.1 MB
fedora            latest    ded7cd95e059     4 weeks ago      186.5 MB
hello-world       latest    91c95931e552     10 weeks ago     910 B
```

So we can verify that a new CentOS 6 image has been downloaded and based on it a new image has been created (without name nor tag, just an ID) containing httpd installed with its dependencies. Check it by instantiating a container based on that image and launching httpd in it:

`#` **`docker run -ti 358657a2b6b0 /bin/bash`**

`[root@babbfd33b239 /]#` **`httpd `**
```
httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.5 for ServerName
```
Note : The above message is just a warning, as an evidence, you can see the processes running with the next command.

`[root@babbfd33b239 /]#` **`ps auxww |grep htt`**
```
root        14  0.0  0.0 175336  6360 ?        Ss   14:36   0:00 httpd
apache      15  0.0  0.0 175336  3824 ?        S    14:36   0:00 httpd
apache      16  0.0  0.0 175336  3824 ?        S    14:36   0:00 httpd
apache      17  0.0  0.0 175336  3824 ?        S    14:36   0:00 httpd
apache      18  0.0  0.0 175336  3824 ?        S    14:36   0:00 httpd
apache      19  0.0  0.0 175336  3824 ?        S    14:36   0:00 httpd
apache      20  0.0  0.0 175336  3824 ?        S    14:36   0:00 httpd
apache      21  0.0  0.0 175336  3824 ?        S    14:36   0:00 httpd
apache      22  0.0  0.0 175336  3824 ?        S    14:36   0:00 httpd
root        24  0.0  0.0   9728  2128 ?        S+   14:37   0:00 grep htt
```
`[root@babbfd33b239 /]#` **`exit`**

`#` **`docker ps -a`**
```
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                      PORTS               NAMES
babbfd33b239        358657a2b6b0        "/bin/bash"         About a minute ago   Exited (0) 16 seconds ago                       sharp_hodgkin
[...]
```
`#` **`docker diff babbfd33b239`**
```
C /root
A /root/.bash_history
C /tmp
C /var
C /var/log
C /var/log/httpd
A /var/log/httpd/access_log
A /var/log/httpd/error_log
C /var/run
C /var/run/httpd
A /var/run/httpd/httpd.pid
```
`#` **`docker history 358657a2b6b0`**
```
IMAGE        CREATED        CREATED BY                            SIZE
358657a2b6b0 13 minutes ago /bin/sh -c yum install -y httpd       71.75 MB
a005304e4e74 12 days ago    /bin/sh -c #(nop) CMD ["/bin/bash"]   0 B
fb9cc58bde0c 12 days ago    /bin/sh -c #(nop) ADD file:36d5dedfe  203.1 MB
f1b10cd84249 10 weeks ago   /bin/sh -c #(nop) MAINTAINER The Cent 0 B
```

So we checked that we can launch the httpd server from inside an instantiated container made from our image. We also checked how our image was built. Note that the image built is 72 MB larger than the base CentOS 6 one (shown by history) and has sensible modifications shown by the diff command.
It's a good start, but now we would like to have our httpd server started automatically with our container creation. And have attribution accordingly ;-)

`#` **`cat >> Dockerfile << EOF`**
```
MAINTAINER myself@mydomain.org
CMD httpd
EOF
```
`#` **`docker build .`**
```
Sending build context to Docker daemon  12.8 kB
Sending build context to Docker daemon
Step 0 : FROM centos:6
 ---> a005304e4e74
Step 1 : RUN yum install -y httpd
 ---> Using cache
 ---> 358657a2b6b0
Step 2 : MAINTAINER myself@mydomain.org
 ---> Running in dd5b4613f9ab
 ---> 1c93d00d212f
Removing intermediate container dd5b4613f9ab
Step 3 : CMD httpd
 ---> Running in b9fb6c35de95
 ---> 76cec1da7808
Removing intermediate container b9fb6c35de95
Successfully built 76cec1da7808
```

You can remark that all the first steps are very quick. This is because Docker caches steps, and will not repeat them unless the Dockerfile changes. You can modify the Docker file by putting the `MAINTAINER` command as the second line and re-launch the build. You'll see that in that case Docker invalidates its cache and restarts.
Now start a container from that image to check the web server is indeed started

`#` **`docker run -ti 76cec1da7808`**
```
httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.6 for ServerName
```
1. What happened ? Why don't you get a prompt ?
2. Use `docker ps` to see the status of your container and `docker logs` to see what happened.
3. Try to adapt the Dockerfile to solve that issue. **Discuss with your trainer if you're stuck !**

`#` **`perl -pi -e 's|D httpd|D /usr/sbin/apachectl -DFOREGROUND -k start|' Dockerfile`**
(This magic command replaces the launch of the httpd command by the apachectl one with the right options. If you are using CentOS 7 as the host OS, you will have to install perl via yum).

1. Try to use a browser (you may want to install lynx) to connect to your web server. Can you do it ?
2. Which IP address do you point to ? You can use `docker exec` to get the IP address for the container.

By default, the container ports are not exposed outside of the container. So you can't use your host OS to access your isolated webserver. If you are running the container locally navigate to http://localhost in the host browser. If the container is running on lab instruture navigate to http://10.3.222.x (as directed by the instructor).

You will have to explicitly open container port 80 to allow access to the web server running in the container. This will require changes to the Dockerfile:

`#` **`cat >> Dockerfile << EOF`**
```
EXPOSE 80
EOF
```

`#` **`docker build .`**
```
[...]
Successfully built 04d9c18da22a
```
`#` **`docker run -d -p 80:80 04d9c18da22a`**

`#` **`docker ps`**
```
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                NAMES
04d9c18da22a        c1c58f087482        "/bin/sh -c '/usr/sb   4 seconds ago       Up 3 seconds        0.0.0.0:80->80/tcp   thirsty_yalow
```

Now that we have exposed the port, we're able to launch our container in daemon mode (-d) and redirect the local port 80 to the container port 80. Our web server is listening is listening on port 80 in the container. Repeat the earlier attempt to connect to the web server in the container. You should see a CentOS based page on your host distribution.

It's now time to add some content to our web server !
Modify again the Dockerfile to add owncloud to our image:

`#` **`cat >> Dockerfile << EOF`**
```
RUN yum install -y tar bzip2
ADD http://labossi.hpintelco.net/owncloud-7.0.15.tar.bz2 /var/www/html/
# Add this only if before docker engone 17.03
# RUN cd /var/www/html/ && tar xvfj owncloud-7.0.15.tar.bz2 && rm -f owncloud-7.0.15.tar.bz2
EOF
```
We can directly point to a URL, Docker will download the content and extract it in place.
Try now to connect to your owncloud instance. The URL is http://10.3.222.X/owncloud if we host the lab or http://localhost/owncloud if you run it locally.

![Owncloud failed](/Docker/img/owncloud_without_dep.png)

1. What happens?
2. What should you do next to solve the issue ? **Discuss with your trainer if you're stuck !**

Hint, you probably need to add the owncloud dependencies to be able to launch it. Open your Dockerfile and add the following line after the last ADD

**`RUN yum install -y php php-dom php-mbstring php-pdo php-gd`**

With that you should be able to use owncloud ! (Note that you need to use that version with CentOS 6 for a PHP dependency management) But we're not done yet !!!
If you log on to your owncloud instance, and start customizing it (login/passwd for admin, storage path), you'll have errors first, that we'll fix later on and then if you `Docker stop` and `Docker rm` the container to relaunch it again, of course, none of this customization will be kept as it's not part of your container content.

So we now have to deal with storage management for our Docker container. First we need to solve the error generated when you tried to configure your owncloud instance. We had rights issues. Use the following command to help solve the issue:

`#` **`docker exec b42f9f6f1034 ls -al /var/www/html`**

`#` **`docker exec b42f9f6f1034 ps auxww | grep httpd`**

The principle is that the owner of the httpd process should have the rights on the owncloud directory to read and store files there. So modify you Dockerfile accordingly and retest.

Now you should be able to customize your owncloud instance and start using it.
By now you have probably remarked that the ADD order is done each time, without any benefit from the cache management of Docker. Also you have to each time deal with IDs for containers and images, which is not that convenient. Let's fix that. Download the owncloud tar file in your directory and modify the ADD line:

`#` **`wget http://labossi.hpintelco.net/owncloud-7.0.15.tar.bz2`**

`#` **`perl -pi -e 's|ADD http://labossi.hpintelco.net/owncloud-7.0.15.tar.bz2|COPY owncloud-7.0.15.tar.bz2|' Dockerfile`**

`#` **`docker build -t owncloud .`**

Next time you re-run the build, the cache effect is optimal. Also you now have tagged your image and use it by its name:

`#` **`docker images`**
```
REPOSITORY      TAG        IMAGE ID       CREATED             VIRTUAL SIZE
owncloud        latest     de9663de44b2   7 minutes ago       568.5 MB
```

It would be great if you could persist the content from one run to another.  Yes, you can ;-) For that, you need to attach a local directory of your host to your container, and point the setup of your owncloud to that directory instead of the one under `/var/www/html/owncloud`.
Create a `/data` directory on your host, mount it in your container under `/data`, and then point your setup ot it:

`#` **`mkdir -p /data`**

`#` **`date > /data/myfile.txt`**

`#` **`cat >> Dockerfile << EOF`**
```
VOLUME /data
EOF
```
`#` **`docker build -t owncloud .`**

`#` **`docker ps `**
```
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                NAMES
29c8f5ca3d76        de9663de44b2        "/bin/sh -c '/usr/sb   18 minutes ago      Up 18 minutes       0.0.0.0:80->80/tcp   prickly_jang
```
`#` **`docker stop 29c8f5ca3d76 `**

`#` **`docker rm 29c8f5ca3d76`**

`#` **`docker run -d -p 80:80 -v /data:/data owncloud:latest`**

Now reload the owncloud configuration page in your browser, but this time configure the data folder as in the following screen shot:

![Owncloud Setup](/Docker/img/owncloud.png)

If you encounter issues you need to adapt your environment so that the apache user is allowed to write on to the /data directory. Your current Dockerfile should look like this at that point:

`#` **`cat Dockerfile`**
```
FROM centos:6
#FROM fedora:latest
RUN yum install -y httpd
MAINTAINER myself@mydomain.org
RUN yum install -y tar bzip2
COPY owncloud-7.0.15.tar.bz2 /var/www/html/
RUN cd /var/www/html/ && tar xvfj owncloud-7.0.15.tar.bz2 && rm -f owncloud-7.0.15.tar.bz2
RUN yum install -y php php-dom php-mbstring php-pdo php-gd
RUN chown -R apache:apache /var/www/html/owncloud /data
VOLUME /data
CMD /usr/sbin/apachectl -DFOREGROUND -k start
EXPOSE 80
```
Move the example text file you created earlier to your ownClould Documents folder so you can see the file and view the file in ownCloud.

`#` **`mv /data/myfile.txt /data/bruno/files/Documents`**

Open the Documents folder in the ownCloud Web UI. Confirm that the myfile.txt example file is present and then view the contents to check that they match what you created earlier.

`#` **`docker ps`**
```
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                NAMES
23fb18adf4f7        owncloud:latest     "/bin/sh -c '/usr/sb   5 minutes ago       Up 5 minutes        0.0.0.0:80->80/tcp   modest_lalande
```
`#` **`docker stop 23f`**
```
23f
```
`#` **`docker rm 23f`**
```
23f
```
`#` **`docker run -d -p 80:80 -v /data:/data owncloud:latest`**
```
cca4a1776ef12b256616e69a29753202efe0b1af5dd64fecfb638d2a797b234e
```

1. At that point you should find again your data on your owncloud instance right ? But what additional pain point do you have ?
2. Knowing that the owncloud configuration data are located under `/var/www/html/owncloud/config/config.php`  try to adapt the Dockerfile to solve that last issue. **Discuss with your trainer if you're stuck !**
Note : there is more than one way to solve this.

# Using Docker compose

Docker compose is a tool part of the Docker ecosystem.
It is used to run solutions split in multiple containers which is the case most of the time.
This is mainly due to the Docker philosophy to use one container per service.

Another benefit is to define the container running parameters within a YAML configuration file.

## Installing Docker compose

Use the following commands:

`#` **`curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose`**

If that command fails and you're on MacOS X (because the File System is
read-only, then use the target /opt/local/sbin/docker-compose instead)

`#` **`chmod +x /usr/local/bin/docker-compose`**

Check that the binary works by displaying the revision (providing you have
/usr/local/bin in your path):

`#` **`docker-compose --version`**
```
docker-compose version 1.9.0, build 2585387`**
```

## Our first docker-compose.yml file
Now we have a working docker-compose, we need to create an application environment and our first **docker-compose.yml** configuration file.

Create the build environment by moving all our previous stuffs into a folder:

`#` **`mkdir owncloud`**

`#` **`mv Dockerfile owncloud-7.0.15.tar.bz2 config.php owncloud`**

`#` **`cd owncloud`**

Now we can create our configuration file. We will use the new v2.0 format instead of the legacy one. The v2.0 was created to extend functionalities and can be activated by specifying the release at the top of the file.

Note : Of course old docker-compose binaries don't manage v2.0.

`#` **`cat > docker-compose.yml << EOF`**
```
version: '2'
services:
  web:
    build: .
    volumes:
      - /data:/data
    ports:
      - "80:80"
EOF
```

The above file asks to docker-compose to define a web service that will be built from our Dockerfile, to expose port 80 and to map /data on the host to /data in the container.

We can now start our application using:

`#` **`docker-compose up -d`**
```
Creating network "owncloud_default" with the default driver
Creating owncloud_web_1
```

`#` **`docker ps`**
```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
2573be6f1401        owncloud_web        "/bin/sh -c '/usr/sbi"   35 seconds ago      Up 34 seconds       0.0.0.0:80->80/tcp   owncloud_web_1
```

Our application starts and should work the same way as previously. However it is much simpler because we don't need to define ports and storage mapping, also the YAML file can be held in  and this information can be managed in Configuration Management System.

You can also note that the container name is defined as `application_service_number` (owncloud_web_1)

Now stop the application:

`#` **`docker-compose down`**
```
Stopping owncloud_web_1 ... done
Removing owncloud_web_1 ... done
Removing network owncloud_default
```

Check what happens to the container.

Ok that's cool, but it is not really a big change.

## Going further with docker-compose.yml

If we look at our owncloud application, we are using an internal sqlite database. This was defined during the setup phase.

As mentioned during the setup (below), this is convenient for a limited installation, but for larger ones it is better to use mysql/mariadb or postgres.

![Owncloud sqlite setup](/Docker/img/owncloud_setup.png)

In order to install owncloud on another database:

   1. Wipe `config.php` to have the setup page proposed again by the application.
   2. Add the `php-mysql` package to your Dockerfile in the relevant part.
   3. Start the application but use `docker-compose up -d --build` to force the rebuild of the Dockerfile.

![Owncloud sqlite setup](/Docker/img/owncloud_setup_db.png)

Instead of building our own mariadb container from scratch like we did for owncloud, we will use the official Docker one.

Of course it requires some information about the compose-file format. Documentation for this can be found here: https://docs.docker.com/compose/compose-file and the image itself there: https://hub.docker.com/_/mariadb

  1. Try to modify `docker-compose.yml` to add a db service based on the mariadb official images.
  2. We need to provide the database parameters fields (user, password etc...). Hint: Look at the mariadb container environment variables. **Discuss with your trainer if you're stuck !**
  3. What is the hostname of our container ? Hint: Look at the link directive.

If you didn't manage to configure the mariadb container and use it with owncloud, then the additional content for your docker-compose.yml could be useful:
```
  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=owncloud
      - MYSQL_USER=owncloud
      - MYSQL_PASSWORD=owncloudpwd
```

We are now using a mariadb container, but the database content is inside the container. So this is the same story as before, we need to keep our data persistent.

  1. Find out where are managed the db files.
  1. Use a Docker volume to use them from the host.
  2. Modify docker-compose.yml to do that. Hint: separate owncloud and db data under /data to avoid user rights conflicts.

If you manage to configure the mariadb container with persistant data your docker-compose.yml should look like this:
```
version: '2'
services:
  web:
    build: .
    volumes:
      - /data/owncloud:/data/owncloud
    ports:
      - "80:80"
    links:
      - db:mariadb
  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=owncloud
      - MYSQL_USER=owncloud
      - MYSQL_PASSWORD=owncloudpwd
    volumes:
      - /data/db:/var/lib/mysql
```

`#` **`docker-compose ps`**
```
     Name                   Command               State         Ports
----------------------------------------------------------------------------
owncloud_db_1    docker-entrypoint.sh mysqld      Up      3306/tcp
owncloud_web_1   /bin/sh -c /usr/sbin/apach ...   Up      0.0.0.0:80->80/tcp
```

You would like to try to allow scalability for your application by scaling the
web service

`#` **`docker-compose scale web=2`**

Detect whether this is working or not and why. If not, we'll find another way
to solve this.


# Using docker-machine to create Docker hosts

Depending on the context of the Lab, you may already have enough machines available (5) to run the Swarm part, or you may need to create them. In that case, continue with this part, if not, skip to the next one.

docker-machine is a Docker tool that can be used to deploy Docker hosts on various cloud platforms (AWS, Azure, Digital Ocean, Openstack, etc...).
We will use this tool to deploy 5 nodes that will be used later in the Swarm part. Docker machine simply deploys a server on your favorite provider and then installs the latest release of Docker Engine.

The following command will deploy one node to our openstack environment but will not run it yet.

`#` **`docker-machine create --driver openstack --openstack-auth-url http://10.11.50.26:5000/v2.0 --openstack-flavor-name m1.small --openstack-image-name ubuntu1604 --openstack-username dockerlab --openstack-password Linux1 --openstack-tenant-name dockerlab --openstack-net-name private --openstack-floatingip-pool external-network --openstack-sec-groups default --openstack-ssh-user ubuntu dockerw1`**

In order to save time we will deploy 5 hosts in parallel with the following command.
```
for i in dockerm1 dockerm2 dockerm3 dockerw1 dockerw2; do
    docker-machine create --driver openstack --openstack-auth-url http://10.11.50.26:5000/v2.0 --openstack-flavor-name m1.small --openstack-image-name ubuntu1604 --openstack-username dockerlab --openstack-password linux1 --openstack-tenant-name dockerlab --openstack-net-name private --openstack-floatingip-pool external-network --openstack-sec-groups default --openstack-ssh-user ubuntu $i &
done
```

This will take around 5mn. You can list the machines installed with the command:
`docker-machine ls`

To connect to a server you can use:
`docker-machine ssh <machine_name>`

Docker CLI always uses the API. So you can configure the CLI to use a remote host instead of your local Unix socket. That way your client will act as usual but instead of managing your local engine, it will manage a remote one.
Example, suppose you want to interact with the dockerm1 machine. Just type the following command:

`#` **`docker-machine env dockerm1`**

The above command will provide the env variable and the command to export them in the environment. So using

`#` **`eval $(docker-machine env dockerm1)`**

you can now work with Docker as usual, however all commands passed will operate on the remote host.


# Using Docker Swarm

Docker Swarm is, since version 1.12, part of Docker Engine.
It is used to provide high availability for Docker containers.

A really complete and excellent workshop is available for Swarm at https://jpetazzo.github.io/orchestration-workshop
We extracted lots of ideas from it to lead you towards a first understanding of Swarm.

## Installing Docker Swarm

If you have a version prior to 1.13, then you'll need to install Docker Engine 1.13+ as the rest of this lab requires that version.

## Installing on CentOS 7

On CentOS 7 just add the repo file mentioned earlier in this Lab to get it.

<!--
## Installing on Ubuntu
## Installing the engine manually
-->

## Installing the engine in the Cloud

If you followed docker-machine part, you can now use these machines to configure a Swarm cluster as you have the latest version available in them.

## Using Docker Swarm to make our configuration available and scalable

So now that we can orchestrate the creation of our 2 containers hosting our
application, we would like to make it scalable and error proof. Let's try to
look at which nodes are available on our cluster:

`#` **`docker node ls`**
```
Error response from daemon: This node is not a swarm manager. Use "docker swarm init" or "docker swarm join" to connect this node to swarm and try again.
```
Ok, so you need first to initiate a swarm cluster ! Let's do it on our node as
instructed:

`#` **`docker swarm init`**
```
Swarm initialized: current node (82mm398yajdl4lor2gzc4eeeo) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-444fdgnkvchgol08ck8rexwhxg8hbvwncyqs61mvcu0b3978qs-4r5p96yudo5r1x6c4psxd1uyt \
    10.11.51.136:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

So use the previous advise to add your other nodes to the Swarm cluster as worker.

`#` **`docker node ls`**
```
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
2cosbse8y5o1sl2zr4o2tc06q    c11.labossi.hpintelco.org  Ready   Active
31n32lc4wjv9oskc6ejyvxz9j *  c6.labossi.hpintelco.org   Ready   Active        Leader
51kz6qmid4blq7pjbrq5527o5    c7.labossi.hpintelco.org   Ready   Active
726rg84phfkohofjpn8p2ztfg    c8.labossi.hpintelco.org   Ready   Active
d8dfb2e8qd3h703pw43o5r88f    c10.labossi.hpintelco.org  Ready   Active
```

Check what you can see on each node. Also look at the output of the `docker info` command.

If you have problems with error messages like "Error response from daemon: Timeout was reached before node was joined." then you firewall may be blocking the ports that Docker Swarm uses. If you think this is the case, you may have firewalling issues ;-)

### Configuring firewall on CentOS7

Look at https://www.digitalocean.com/community/tutorials/how-to-configure-the-linux-firewall-for-docker-swarm-on-centos-7

I recommend that you run the following commands on **all** nodes to avoid firewalling issue in the rest of the Lab:

`#` **`firewall-cmd --add-port=2376/tcp --permanent`**

`#` **`firewall-cmd --add-port=2377/tcp --permanent`**

`#` **`firewall-cmd --add-port=7946/tcp --permanent`**

`#` **`firewall-cmd --add-port=7946/udp --permanent`**

`#` **`firewall-cmd --add-port=4789/udp --permanent`**

But you will probably have many issues with firewalld later on anyway, so it's worth disabling it now on all nodes to avoid solving unrelated issues and integration aspects with Docker iptables management (been there done that for hours !). And believe me, I don't like that :-( (so in our Lab we have peripheral firewall !). For that use:

`#` **`systemctl stop firewalld`**
`#` **`systemctl restart docker`**

This previous command re-establish the NAT rules set up by Docker and that
have been reset just previously.

### Configuring firewall on Ubuntu

I recommend that you run the following command on **all** nodes to avoid firewalling issue in the rest of the Lab:

`#` **`ufw disable`**

Back to out normal program now !

Swarm has the notion of worker (hosting containers), manager (able to be also
a worker and being a backup leader) and Leader (manager being in charge of the
Swarm cluster).

In order to render our cluster highly available, we need to have an odd number
of managers. Here we can promote 2 of our workers as managers. For that, we
need to get another token, the manager one, instead of the worker one we used
previously.

`#` **`docker swarm join-token -q manager`**
```
SWMTKN-1-444fdgnkvchgol08ck8rexwhxg8hbvwncyqs61mvcu0b3978qs-cw10maud95375a2t35p7m5kox
```

So now you have the right token, use it as previously on 2 of your nodes to
promote them as managers.

Example:
`#` **`docker node promote c7.labossi.hpintelco.org`**

At the end you should get the following result:

`#` **`docker node ls`**
```
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
2cosbse8y5o1sl2zr4o2tc06q    c11.labossi.hpintelco.org  Ready   Active
31n32lc4wjv9oskc6ejyvxz9j *  c6.labossi.hpintelco.org   Ready   Active        Leader
51kz6qmid4blq7pjbrq5527o5    c7.labossi.hpintelco.org   Ready   Active        Reachable
726rg84phfkohofjpn8p2ztfg    c8.labossi.hpintelco.org   Ready   Active        Reachable
d8dfb2e8qd3h703pw43o5r88f    c10.labossi.hpintelco.org  Ready   Active
```

There are many ways to do it, including using docker node update.

So now that we have a cluster running, it would be a good idea to launch
containers on it. But in a Swarm cluster this means creating services. So
let's create a simple service to test our cluster:

`#` **`docker service create alpine ping 8.8.8.8`**
```
ag12vg6ts417gj4r2y2w57j5q
```

`#` **`docker service ls`**
```
ID            NAME         REPLICAS  IMAGE   COMMAND
ag12vg6ts417  tiny_curran  1/1       alpine  ping 8.8.8.8

```

`#` **`docker service ps ag1`**
```
ID                         NAME                   IMAGE   NODE     DESIRED STATE  CURRENT STATE              ERROR
9aq9iq25ayhp1nk11ems7tsly  tiny_curran.1  alpine  c6.labossi.hpintelco.org  Running        Running 35 seconds ago
```

Use the Docker commands to check how the container is behaving in your
environment. Restart the Docker daemon on the leader node and look at the
cluster behaviour.

You can scale that service:

`#` **`docker service update ag1 --replicas 10`**
```
ag1
```

Check what happens. You can use docker ps on the current node, and on another node.

In order to help visualize the state of the Swarm cluster you can use the visualizer companion of Swarm. On the master node run the following:

`#` **`docker run -it -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock manomarks/visualizer`**

And then connect your browser to it on port 8080. You should see something similar to the below image:
![Swarm Visualizer](/Docker/img/visualizer.png)

Now let's put on our cluster our application. With recent versions of docker-compose, there is the new notion of stack to orchestrate services. Adapt your docker-compose to use it following the below model:
```
version: '3'
services:
  web:
    build: .
    volumes:
      - /data/owncloud:/data/owncloud
      - /data/config:/var/www/html/owncloud/config
    ports:
      - "8000:80"
    links:
      - db:mariadb
    networks:
      oclan:
  db:
    image: mariadb
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=owncloud
      - MYSQL_USER=owncloud
      - MYSQL_PASSWORD=owncloudpwd
    volumes:
      - /data/db:/var/lib/mysql
    networks:
      oclan:
        aliases:
          - db
networks:
    oclan:
        driver: overlay
```

Compared to the v2 file, the main change is that you're now defining in it your network to allow communication between containers

Now start your stack:

`#` **`docker stack deploy -c docker-compose-v3.yml oc`**
```
Ignoring unsupported options: build, links

Creating service oc_web
Creating service oc_db
```
You may have some problems with this. Try to understand what happens and solve your issues. How many replicas are working ? Where are the images to use ? Which node can use them ?
Hint: use the command `docker stack services oc` to help diagnose. And as usual talk to your instructor !

So you will need to use a private registry here to help solving that issue.

We have deployed a Docker registry for you, available from a URL that will be provided by the instructor.
(If you use the internal HPE Lab, then try lab7-2.labossi.hpintelco.org:5500 - If you want to create your own, use our scripts at https://github.com/bcornec/Labs/tree/master/Docker/registry)

You need to add the CA public certificate made on the registry to trust it.
Download the CA from the registry web site:

### CentOS 7

`#` **`curl -L http://lab7-2.labossi.hpintelco.org/ca.crt > /etc/pki/ca-trust/source/anchors/ca-registry.crt`**

`#` **`update-ca-trust`**

`#` **`systemctl restart docker`**

### Ubuntu/Debian

`#` **`curl -L http://lab7-2.labossi.hpintelco.org/ca.crt > /usr/local/share/ca-certificates/ca-registry.crt`**

`#` **`update-ca-certificates`**

`#` **`service docker restart`**

Check that the registry runs as expected:
`#` **`curl -L https://<my-registry-fqdn>:5500/v2`**
`{}`

Of course, each node needs to be configured identically.

In order to share the image between the nodes, you need to push it to this new
registry, by using the appropriate tag. For example, you may use a command similar to

`#` **`docker tag owncloud_web:latest ${DOMAIN_NAME}:5500/owncloud_web`**

And then you can push that image into our registry so it's available to other engines to use.

`#` **`docker push ${DOMAIN_NAME}:5500/owncloud_web`**

Do the same with the mariadb service that you create afterwards following the same approach.
Look at your stack status. Is everything working fine or not ? What happens if you kill the httpd process ? the mysql process ? Explain what is happening.

Now for the storage it's more difficult as the volumes you want to mount should be, as the images previously, available on all engines so each container created on it can use these data. One way to solve this for the mariadb image is to use an NFS exported directory from your first node.
Let's configure NFS on the first machine (10.11.51.136 in my case):

`#` **`yum install -y nfs-utils`** # CentOS7

or

`#` **`apt-get install -y nfs-server`** # Ubuntu

Edit the exports file so it looks like:

`#` **`cat /etc/exports`**
```
/data/db        *.labossi.hpintelco.org(rw,no_root_squash,async,insecure,no_subtree_check)
/data/owncloud  *.labossi.hpintelco.org(rw,no_root_squash,async,insecure,no_subtree_check)
/data/config    *.labossi.hpintelco.org(rw,no_root_squash,async,insecure,no_subtree_check)
```
`#` **`exportfs -a`**

`#` **`systemctl start nfs`**

Check on another node that your NFS setup is correct.

Now you can create a Docker volume that will be used by the containers launched with a service, by amending your docker-compose file which should now look like this:

```
version: '3'
services:
  web:
    build: .
    image: lab7-2.labossi.hpintelco.org:5500/owncloud_web
    volumes:
      - /data/owncloud:/data/owncloud
      - /data/config:/var/www/html/owncloud/config
    ports:
      - "8000:80"
    links:
      - db:mariadb
    networks:
      oclan:
  db:
    image: mariadb
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=owncloud
      - MYSQL_USER=owncloud
      - MYSQL_PASSWORD=owncloudpwd
    volumes:
      - dbvol:/var/lib/mysql
    networks:
      oclan:
        aliases:
          - db
networks:
    oclan:
        driver: overlay

volumes:
  dbvol:
    driver: local
    driver_opts:
      type: nfs
      o: addr=10.11.51.136,rw
      device: ":/data/db"
```

Restart your stack:
`#` **`docker stack rm oc`**

`#` **`docker stack deploy -c docker-compose-v3.yml oc`**

Check they have now been created with:
`#` **`docker volume ls`**

BTW, you can see that Docker already transparently created many more volumes for you.
Note that you have to do it on all the engines of your Swarm cluster for this method to work.

Is that now working as expected ? If you use Docker 17.03+ you should have the docker service logs command now to help you diagnose your issue. If not, then tip is to use docker service ps <svc_id> to find on which host runs the service and then docker exec/logs on that host e.g. Also think to the /var/log/messages log file on your host.

Can you have access to the database with the mysql command from your host (install the command if you need it) ? Check that the volume is mounted correctly in the container. Check that you can reach the mysql daemon from any host in the cluster. For mysql to work correctly using an NFS exported directory for its files, you will need to have the rpc.statd daemon running on all nodes of your cluster.
Hint:

`#` **`yum install -y nfs-utils`**

`#` **`systemctl start rpc-statd`** # CentOS7

or

`#` **`apt-get install -y nfs-common`**

`#` **`service rpc.statd start`** # Ubuntu

Create a temporary table in the owncloud database to check and then relaunch the service to verify the persistency of the DB.
MariaDB hint:

`#` **`mysql -uowncloud -powncloudpwd`**

`MariaDB [(none)]>` **`use owncloud;`**

`MariaDB [(owncloud)]>` **`create table toto (id int);`**

`MariaDB [(owncloud)]>` **`show tables;`**

`MariaDB [(owncloud)]>` **`quit;`**

Once all this is solved, you can try dealing with the web frontend. Adopt a similar approach (NFS volume and service). Check that the communication between owncloud and the DB works fine.

You may be affected as myself by remaining bugs such as https://github.com/docker/docker/issues/20486 or https://github.com/docker/docker/issues/25981, especially mixing tests with docker-compose and swarm. For me, the only way to turn around them was to reboot the full cluster completely.

Observe what happens when you restart a Docker service on a node hosting one of the 2 services.

We can scale out such a stateful application (while less interesting than a cloud native one) with many owncloud instances to support many users and spread the load across the Swarm cluster.

PLEASE, stop your services to avoid ports conflicts with the next part.

`#` **`docker stack rm oc`**

Now we'll see the adequation of Docker Swarm and Cloud Native applications.

# Deploy a cloud native application.

Let's explain first the application and its goal.

## Objectives

In this section, we will create a promotional lottery for an e-commerce site.
All the software components are provided, you'll "just" have to perform a partial containerzation of the service.

As the setup takes some time, we'll start with the instructions and then you'll have time to read the explanations.

First have access to the application we developed for this.

`#` **`yum install -y git`**

`#` **`git clone https://github.com/bcornec/openstack_lab.git`**

`#` **`cd cloud_native_app`**

As you can see in the openstack_lab directory created, the same application can be used for a Docker or an OpenStack usage (or combining them).
The application is still a WIP, so don't worry with all the additional files and directories for now. Upstream is at https://github.com/uggla/openstack_lab.git alongside its documentation.

We need first to run the application locally using the compose file, in order to create all the Docker images and to upload them into the registry.

`#` **`./docker_services.sh`**

Drink a coffee, it's well deserved at that point, the composition takes a bit of time. Or stay looking at it to observe closely the magic of Docker automation ;-)
Please start reading the following explanations in or to understand what we're building for you here.

A customer of a big e-commerce site receives a promotional email with a link to win a prize if they are lucky.
The application detects whether the player already played or not, and whether he won already or not.
Each status is kept with the date when it was performed. The application provides a button allowing the customer to play, in case he didn't already, and the result of the computation which happens behind the scene is given back to the customer: it is the nature of the article he has won, and the corresponding image is displayed in the interface. Mails are sent to admins when a winner is found.

That application is made of one Web page with 5 parts/micro-services: I, S, B, W and P:
  - I(dentification) service: receives http request from customer (link with customer ID) and look for it into the DB.
  - S(tatus) service: detect whether customer already played or not, status stored in the DB. It is using a messages bus to buffer requests.
  - B(utton) service: button widget allowing the customer to play. Only when not already done.
  - W(orker) service that computes whether the customer won or not (slow service on purpose with a REST API interface), called by B. If won, post an image representing what has been won into an object store with customer ID. Then post by e-mail via an external provider a message to admins (using a messages bus). Button is gray if the customer has already played. W and the DB are on a separate private network.
  - P(icture) service: Look into the object store with customer ID to display the image of the customer's prize, empty if no image.

Each part of the web page is implemented as a micro-service. So the application supports nicely the death of any one of the 5 micro-services. The page is still displayed anyway, printing N/A when a micro-service is unavailable. In case of insufficient resources (as with the slow W micro-service), we will look at how to scale that application.

Please have a look at the `docker_services.sh` script and adapt what needs to be changed for your environment at the start in case of issues.

At the end of the script you should get a list of services running similar to the one below:
```
ID            NAME         REPLICAS  IMAGE                                                 COMMAND
1empjc9o6wwu  w            1/1       lab7-2.labossi.hpintelco.org:5500/cloudnativeapp_w
1z53fru1vjr6  i            1/1       lab7-2.labossi.hpintelco.org:5500/cloudnativeapp_i
3gasrkzgpp0w  b            1/1       lab7-2.labossi.hpintelco.org:5500/cloudnativeapp_b
3sc3qexaixkl  redis        1/1       redis
4c5i32juwnyh  myownsvc     1/1       lab7-2.labossi.hpintelco.org:5500/owncloud_web
5yl1168mm6h4  w2           1/1       lab7-2.labossi.hpintelco.org:5500/cloudnativeapp_w2
6leldkqf1zth  ping         global    alpine                                                ping 8.8.8.8
79jwqr43zyt2  web          1/1       lab7-2.labossi.hpintelco.org:5500/cloudnativeapp_web
7hygz6g0lbyq  db           1/1       lab7-2.labossi.hpintelco.org:5500/cloudnativeapp_db
9i4ogenk03ax  rabbit       1/1       rabbitmq:3-management
ag12vg6ts417  tiny_curran  10/10     alpine                                                ping 8.8.8.8
ajcrqc6nykn8  s            1/1       lab7-2.labossi.hpintelco.org:5500/cloudnativeapp_s
cn81a9a5j8yi  w1           1/1       lab7-2.labossi.hpintelco.org:5500/cloudnativeapp_w1
e6c6ypgcxdy2  p            1/1       lab7-2.labossi.hpintelco.org:5500/cloudnativeapp_p
```

In order to use the application you'll now have to connect to your system hosting th web application (in our case http://c6.labossi.hpintelco.org/)

You should see a message in your browser saying:
```
Please provide a user id !
```

So now to use the application, you have to provide the id of the user who is playing to see his prize.
Browse http://c6.labossi.hpintelco.org/index.html?id=1

Check the availability of the application by restarting a docker daemon on a host running one of the containers the application is using.
Check the micro-service behavior by stopping the 'i' micro-service, and then the 'p' micro-service. Reload the Web page each time to see what happens.

Try to make more connections. What is the problem encountered.
Which micro-service is causing the issue.
Scale that micro-service to solve the problem.

This is the end of this lab for now, we hope you enjoyed it.

Github issues and pull requests to improve this lab are welcome.
