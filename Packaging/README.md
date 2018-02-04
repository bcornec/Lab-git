# Linux Packaging Lab Contents

The goal of this lab is to become familiar with Linux packaging and handle some of the common use cases around it. By the end of this lab you will have created a packaged application for your distribution, and look at how to support a multi-distribution approach as well.

## Lab Writers and Trainers
  - Bruno.Cornec@hpe.com

## Objectives of the Packaging Lab
At the end of the Lab students should be able to package an application, check its installation under a packaged format, integrate it in a repository, verify the reliability of what is produced.

This Lab is intended to be trial and error so that during the session students should understand really what is behind the tools.  Blindly following instructions is not an effective way to learn IMHO. You've been warned ;-)

Expected duration : 120 minutes

## Reference documents
When dealing with Linux packaging some docuemnt of reference might be useful to consider:

 1. The still relevant Maximum RPM guide at http://ftp.rpm.org/max-rpm/
 1. Fedora packaging guidelines at https://fedoraproject.org/wiki/Packaging:Guidelines
 2. The corresponding reference guide for Debian at https://www.debian.org/doc/manuals/maint-guide/

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

Commands to be executed as root user are prefixed with a **`#`** prompt, while commands to be executed as a normal user are prefixed with the **`$`** prompt.

# Environment setup
Estimated time: 10 minutes

## Proxy consideration

This lab is usually run in our environment that has a direct access to the Internet. If you want to run this lab on your site behind a corporate proxy, you will have to configure your Linux distribution to access the Internet via your proxy.

 1. Get the proxy IP and port.
 2. Make sure your host can resolve the proxy address using `nslookup <proxy>`, if not use the proxy IP.
 3. Configure your Linux package manager to go through the proxy by exporting the http_proxy and https_proxy environment variables:

```
export http_proxy=http://<proxy name or ip>:<proxy port>
export https_proxy=http://<proxy name or ip>:<proxy port>
```

You may have to add some of these instructions in the configuration files of the package manager tomake your life easier.


## Dependencies installation
Ask to your instructor which Linux distribution will be used for the Lab (Ubuntu or CentOS). Then refer to the corresponding instructions below.

Other distributions should be as easy to deal with once the same packages have been installed using the package manager as they should be available directly (Case of most non-commercial distributions such as Debian, Fedora, Mageia, OpenSUSE, ...). Follow the instructions they provide.

### CentOS installation

If you work on a CentOS 7 environment for the Lab, you may want to use yum to do the installation of all the dependencies.

`#` **`yum install wget make patch rpm-build rpmdevtools diffutils sudo`**

### Debian and Ubuntu installation

If you work on a Debian or Ubuntu environment for the Lab, you may want to use apt to do the installation of all the dependencies.

`#` **`sudo apt-get update`**

`#` **`sudo apt-get install wget patch dpkg-dev make debian-builder dh-make fakeroot diffutil sudo`**

# Managing RPM Packages
Estimated time: 15 minutes.

In order to be able to manage packages, the easiest approach is to use an existing one, before creating your own. Of course, if you're already very familiar with package usage on Linux, you may skip that part to go to the next one. The management of package will consists here in searching for them, choosing them, installing them, removing them, upgrading them, ... using both the **`yum`** and the **`rpm`** commands.

Each RPM based distribution maintains a repository of packages from where you can search and install additional components on your distribution. For example, search and install the nano editor on your system:

`#` **`nano`**
`bash: nano: command not found`

`#` **`yum search nano`**
```
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: mirror.team-cymru.org
 * extras: mirror.raystedman.net
 * updates: mirror.team-cymru.org
========================================================================================= N/S matched: nano =========================================================================================
nano.x86_64 : A small text editor

  Name and summary matches only, use "search all" for everything.
```

`#` **`yum info nano`**
```
Loaded plugins: fastestmirror, ovl
[...]
Available Packages
Name        : nano
Arch        : x86_64
Version     : 2.3.1
Release     : 10.el7
Size        : 440 k
Repo        : base/7/x86_64
Summary     : A small text editor
URL         : http://www.nano-editor.org
License     : GPLv3+
Description : GNU nano is a small and friendly text editor.
```

`#` **`yum install nano`**
```
Loaded plugins: fastestmirror, ovl
[...]
Resolving Dependencies
--> Running transaction check
---> Package nano.x86_64 0:2.3.1-10.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=====================================================================================================================================================================================================
 Package                                      Arch                                           Version                                              Repository                                    Size
=====================================================================================================================================================================================================
Installing:
 nano                                         x86_64                                         2.3.1-10.el7                                         base                                         440 k

Transaction Summary
=====================================================================================================================================================================================================
Install  1 Package

Total download size: 440 k
Installed size: 1.6 M
Is this ok [y/d/N]: **y**
Downloading packages:
nano-2.3.1-10.el7.x86_64.rpm                                                                                                                                                  | 440 kB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : nano-2.3.1-10.el7.x86_64                                                                                                                                                          1/1 
  Verifying  : nano-2.3.1-10.el7.x86_64                                                                                                                                                          1/1 

Installed:
  nano.x86_64 0:2.3.1-10.el7                                                                                                                                                                         

Complete!
```

`#` **`nano`**

Type:

`#` **`yum remove nano`**

to get rid of this package.

**`yum`** is very handy for package management using repositories. The repositories used are declared using configuration files hosted under the **`/etc/yum.repos.d`** directory. You can extend the number of repositories considered when managing packages by adding configuration files there, and of course, the corresponding set of packages and indexes at the URL pointed to into these files.

You can also search for packages using key words, and not package names when looking for a feature. Try to run:

`#` **`yum search editor`**

**`yum`** is an upper layer on top of the **`rpm`** command which does the job of package management, while the former does the job of repositories management. Let's understand how that command works:

`#` **`wget http://mirror.centos.org/centos/7/os/x86_64/Packages/nano-2.3.1-10.el7.x86_64.rpm`**
```
--2018-02-04 14:01:48--  http://mirror.centos.org/centos/7/os/x86_64/Packages/nano-2.3.1-10.el7.x86_64.rpm
Resolving mirror.centos.org (mirror.centos.org)... 174.121.90.186, 2001:19f0:0:2a:225:90ff:fe08:f840
Connecting to mirror.centos.org (mirror.centos.org)|174.121.90.186|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 450136 (440K) [application/x-rpm]
Saving to: 'nano-2.3.1-10.el7.x86_64.rpm'

100%[===========================================================================================================================================================>] 450,136     1.76MB/s   in 0.2s   

2018-02-04 14:01:49 (1.76 MB/s) - 'nano-2.3.1-10.el7.x86_64.rpm' saved [450136/450136]
```
`#` **`ls -al nano-2.3.1-10.el7.x86_64.rpm`**
`-rw-rw-r-- 1 pkg pkg 450136 Jul  4  2014 nano-2.3.1-10.el7.x86_64.rpm`

`#` **`rpm -qip nano-2.3.1-10.el7.x86_64.rpm`**
```
Name        : nano
Version     : 2.3.1
Release     : 10.el7
Architecture: x86_64
Install Date: (not installed)
Group       : Applications/Editors
Size        : 1715901
License     : GPLv3+
Signature   : RSA/SHA256, Fri Jul  4 03:53:43 2014, Key ID 24c6a8a7f4a80eb5
Source RPM  : nano-2.3.1-10.el7.src.rpm
Build Date  : Tue Jun 10 04:47:54 2014
Build Host  : worker1.bsys.centos.org
Relocations : (not relocatable)
Packager    : CentOS BuildSystem <http://bugs.centos.org>
Vendor      : CentOS
URL         : http://www.nano-editor.org
Summary     : A small text editor
Description :
GNU nano is a small and friendly text editor.
```

Looks probably familiar after the **`yum info`** one, but you see you can geet more details here.

`#` **`rpm -qlp nano-2.3.1-10.el7.x86_64.rpm`**
```
/etc/nanorc
/usr/bin/nano
/usr/bin/rnano
/usr/share/doc/nano-2.3.1
/usr/share/doc/nano-2.3.1/AUTHORS
[...]
/usr/share/doc/nano-2.3.1/nanorc.sample
/usr/share/info/nano.info.gz
/usr/share/locale/bg/LC_MESSAGES/nano.mo
[...]
/usr/share/locale/zh_TW/LC_MESSAGES/nano.mo
/usr/share/man/fr/man1/nano.1.gz
/usr/share/man/fr/man1/rnano.1.gz
/usr/share/man/fr/man5/nanorc.5.gz
/usr/share/man/man1/nano.1.gz
/usr/share/man/man1/rnano.1.gz
/usr/share/man/man5/nanorc.5.gz
/usr/share/nano
/usr/share/nano/asm.nanorc
[...]
/usr/share/nano/xml.nanorc
```

So you can get the list of all files that will be installed on your system by `rpm` that way. Let's install again the package, using `rpm` this time:

`#` **`rpm -ivh nano-2.3.1-10.el7.x86_64.rpm`**
```
Preparing...                          ################################# [100%]
Updating / installing...
   1:nano-2.3.1-10.el7                ################################# [100%]
```

`#` **`nano`**

CentOS 7 is a Long Time Support type of distribution. Which means that it tends to provide stable software at time of release, and do not update them to the latest versions, as long as it's not required (security issues). For example, the `nano` package upstream is much more recent as you can check at https://www.nano-editor.org/download.php . Some people have even made updated CentOS 7 packages for nano, that we can use to update our distribution:

`#` **`wget http://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64//nano-2.7.4-3.gf.el7.x86_64.rpm`**
```
--2018-02-04 14:17:54--  http://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64//nano-2.7.4-3.gf.el7.x86_64.rpm
Resolving mirror.ghettoforge.org (mirror.ghettoforge.org)... 45.33.61.104, 2600:3c01::f03c:91ff:feb0:1241
Connecting to mirror.ghettoforge.org (mirror.ghettoforge.org)|45.33.61.104|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 535340 (523K) [application/x-rpm]
Saving to: 'nano-2.7.4-3.gf.el7.x86_64.rpm'

100%[===========================================================================================================================================================>] 535,340     1.08MB/s   in 0.5s   

2018-02-04 14:17:55 (1.08 MB/s) - 'nano-2.7.4-3.gf.el7.x86_64.rpm' saved [535340/535340]
```

`#` **`rpm -ivh nano-2.7.4-3.gf.el7.x86_64.rpm`**

Ok so it seems you have an issue right ?

The RPM database maintains a list of all files installed on the system and prevent conflicts to happen, to keep your system sane. What you really want here is not installing the package, but upgrading it as it already exists. This can be done with:

`#` **`rpm -Fvh nano-2.7.4-3.gf.el7.x86_64.rpm`**
```
warning: nano-2.7.4-3.gf.el7.x86_64.rpm: Header V4 RSA/SHA1 Signature, key ID da8b7718: NOKEY
Preparing...                          ################################# [100%]
Updating / installing...
   1:nano-2.7.4-3.gf.el7              ################################# [ 50%]
Cleaning up / removing...
   2:nano-2.3.1-10.el7                ################################# [100%]
```

Check you now have what you expect:

`#` **`rpm -q nano`**

`#` **`nano --version`**

Now remove the package:

`#` **`rpm -e nano`**

`#` **`nano --version`**

And start again, but this time using repositories and new commands ! People have created an additional repository containing additional CentOS 7 packages as well as updates for the distribution (called often backports). They also have created a package which prepare the repository setup on your distribution to use `yum` flowalessly afterwards. Let's look at that: 

`#` **`rpm -Uvh http://mirror.ghettoforge.org/distributions/gf/el/7/gf/x86_64/gf-release-7-10.gf.el7.noarch.rpm`**

`#` **`rpm -ql gf-release`**

`#` **`cat /etc/yum.repos.d/gf.repo`**

`#` **`yum --enablerepo=gf-plus install nano`**

`#` **`nano --version`**

Clean up this setup:

`#` **`rpm -e nano gf-release`**

Look at the man pages for `yum` and `rpm` to learn more about them.

# Building RPM Packages
## The first package

First the best practice to work on packages is to work as a normal user, not as root. Building as root, if you have errors i nyour build configuration may lead to an unusable system, so it's important (and ture in geenral) to just adopt the minimum set of priviledges required for the operations we do. Of course, installing the package, once built, will require root priviledges, but everything else should be performed as a normal user.

`#` **`useradd pkg`**

`#` **`passwd pkg`**

For that we will use the rpmdev-newspec command to generate the template we need for our test executable. first create the "application" we want to package:

`#` **`cat > hello-world.sh << EOF`**
```
#!/bin/bash
echo "Hello Packaging World"
EOF
```

`#` **`chmod 755 hello-world.sh`**

`#` **`./hello-world.sh`**


Then create the template for our package:

`#` **`docker run hello-world`**
```
Unable to find image 'hello-world:latest' locally

# Configuring owncloud in a container

Estimated time: 60 minutes.

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

# Package a cloud native application.

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
