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
 1. RPM packaging guide at https://rpm-packaging-guide.github.io/
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

`#` **`yum install wget make patch rpm-build rpmdevtools rpmlint diffutils sudo`**

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
Estimated time: 15 minutes.

First the best practice to work on packages is to work as a normal user, not as root. Building as root, if you have errors in your build configuration may lead to an unusable system, so it's important (and sure in general) to just adopt the minimum set of priviledges required for the operations we do. Of course, installing the package, once built, will require root priviledges as seen previously, but everything else should be performed as a normal user. You may open 2 terminals one as a user, the other one as root to ease operations.

`#` **`useradd pkg`**

`#` **`passwd pkg`**

the packages RPM packages are created is through the usage of a spec file. So, you first have to create one in order to build your package.
For that we will use the `rpmdev-newspec` command to generate the template we need for our test executable. First create the "application" we want to package:

`#` **`su - pkg`**

`$` **`cat > hello-world.sh << EOF`**
```
#!/bin/bash
echo "Hello Packaging World"
EOF
```

`$` **`chmod 755 hello-world.sh`**

`$` **`./hello-world.sh`**
```
Hello Packaging World
```


Then create the template for our package:

`$` **`rpmdev-newspec hello-world`**

Look at its content and modify it so it corresponds to the following:

`$` **`cat hello-world.spec`**
```
Name:           hello-world
Version:        1.0
Release:        1
Summary:        A simple hello world application

License:        GPLv3
URL:            None-yet
Source0:        hello-world.sh

#BuildRequires:  
Requires:       bash

%description
A simple hello world application

%prep
##setup -q

%build
##configure
#make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
##make_install
mkdir -p $RPM_BUILD_ROOT/%{_bindir}
cp %{SOURCE0} $RPM_BUILD_ROOT/%{_bindir}


%files
%{_bindir}/%{name}.sh

##doc

%changelog
* Sun Feb 04 2018 Bruno Cornec <pingouin@hpe.com> 1.0-1
- First Import
```

We commented the `%prep` and `%build` phases as we do not have anything to build yet. We just need to copy one file at installation time. Also we need to refer to it in the files section, so the package knows which files it manages (there is no magic, if you don't tell it, rpm won't guess).

Now try to build your first package with:

`$` **`rpmbuild -ba hello-world.spec`**
```
Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.UphFwA
+ umask 022
+ cd /home/pkg/rpmbuild/BUILD
+ exit 0
Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.tZ3FjV
+ umask 022
+ cd /home/pkg/rpmbuild/BUILD
+ exit 0
Executing(%install): /bin/sh -e /var/tmp/rpm-tmp.bWS86f
+ umask 022
+ cd /home/pkg/rpmbuild/BUILD
+ '[' /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64 '!=' / ']'
+ rm -rf /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
++ dirname /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
+ mkdir -p /home/pkg/rpmbuild/BUILDROOT
+ mkdir /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
+ rm -rf /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
+ cp /home/pkg/rpmbuild/SOURCES/hello-world.sh /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64//usr/bin
cp: cannot stat '/home/pkg/rpmbuild/SOURCES/hello-world.sh': No such file or directory
error: Bad exit status from /var/tmp/rpm-tmp.bWS86f (%install)


RPM build errors:
    Bad exit status from /var/tmp/rpm-tmp.bWS86f (%install)
```

This doesn't work. Of course, what did you expect ? You now need to understand what is wrong !

If you look at your directory, you should see that a new subdirectory was created, and below it more directories:

`$` **`ls -R`**
```
.:
hello-world.sh  hello-world.spec  rpmbuild

./rpmbuild:
BUILD  BUILDROOT  RPMS  SOURCES  SPECS  SRPMS

./rpmbuild/BUILD:

./rpmbuild/BUILDROOT:

./rpmbuild/RPMS:

./rpmbuild/SOURCES:

./rpmbuild/SPECS:

./rpmbuild/SRPMS:
```

By default, the rpmbuild command expect to work under the rpmbuild directory in your $HOME directory. And spec files are expected under the SPECS subdirectory, as well as all needed sources under the SOURCES subdirectory. The other directories are used for build generation (BUILD and BUILDROOT) and delivery of built packages (RPMS and SRPMS). So you need to move your files at the expected place for the build to work. A best practice here is also to place the content of the SPECS and SOURCES files under a Version Control System such as git or subversion.

`$` **`mv hello-world.spec rpmbuild/SPECS`**

`$` **`mv hello-world.sh rpmbuild/SOURCES`**

`$` **`cd rpmbuild/SPECS`**

`$` **`rpmbuild -ba hello-world.spec`**
```
Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.TswAHA
+ umask 022
+ cd /home/pkg/rpmbuild/BUILD
+ exit 0
Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.dIscCM
+ umask 022
+ cd /home/pkg/rpmbuild/BUILD
+ exit 0
Executing(%install): /bin/sh -e /var/tmp/rpm-tmp.Qn77wY
+ umask 022
+ cd /home/pkg/rpmbuild/BUILD
+ '[' /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64 '!=' / ']'
+ rm -rf /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
++ dirname /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
+ mkdir -p /home/pkg/rpmbuild/BUILDROOT
+ mkdir /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
+ rm -rf /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
+ mkdir -p /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64//usr/bin
+ cp /home/pkg/rpmbuild/SOURCES/hello-world.sh /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64//usr/bin
+ /usr/lib/rpm/check-buildroot
+ /usr/lib/rpm/redhat/brp-compress
+ /usr/lib/rpm/redhat/brp-strip /usr/bin/strip
+ /usr/lib/rpm/redhat/brp-strip-comment-note /usr/bin/strip /usr/bin/objdump
+ /usr/lib/rpm/redhat/brp-strip-static-archive /usr/bin/strip
+ /usr/lib/rpm/brp-python-bytecompile /usr/bin/python 1
+ /usr/lib/rpm/redhat/brp-python-hardlink
+ /usr/lib/rpm/redhat/brp-java-repack-jars
Processing files: hello-world-1.0-1.x86_64
Provides: hello-world = 1.0-1 hello-world(x86-64) = 1.0-1
Requires(rpmlib): rpmlib(CompressedFileNames) <= 3.0.4-1 rpmlib(FileDigests) <= 4.6.0-1 rpmlib(PayloadFilesHavePrefix) <= 4.0-1
Requires: /bin/bash
Checking for unpackaged file(s): /usr/lib/rpm/check-files /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
Wrote: /home/pkg/rpmbuild/SRPMS/hello-world-1.0-1.src.rpm
Wrote: /home/pkg/rpmbuild/RPMS/x86_64/hello-world-1.0-1.x86_64.rpm
Executing(%clean): /bin/sh -e /var/tmp/rpm-tmp.gvPK3y
+ umask 022
+ cd /home/pkg/rpmbuild/BUILD
+ /usr/bin/rm -rf /home/pkg/rpmbuild/BUILDROOT/hello-world-1.0-1.x86_64
+ exit 0
```

`$` **`(cd ../../ ; ls -R)`**
```
.:
rpmbuild

./rpmbuild:
BUILD  BUILDROOT  RPMS  SOURCES  SPECS  SRPMS

./rpmbuild/BUILD:

./rpmbuild/BUILDROOT:

./rpmbuild/RPMS:
x86_64

./rpmbuild/RPMS/x86_64:
hello-world-1.0-1.x86_64.rpm

./rpmbuild/SOURCES:
hello-world.sh

./rpmbuild/SPECS:
hello-world.spec

./rpmbuild/SRPMS:
hello-world-1.0-1.src.rpm
```

So 2 packages have been created, the one which is of interest to you under rpmbuild/RPMS/x86_64 called the binary package and another one, called the source RPM under rpmbuild/SRPMS. This last one contains everything you need to rebuild the package (the spec and source files) and thus can be provided to another team in order to obtain the same binary package you got, providing the environment is similar.

`$` **`rpm -qlvp ../SRPMS/hello-world-1.0-1.src.rpm`**
```
-rwxr-xr-x    1 pkg     pkg                        41 Feb  5 02:30 hello-world.sh
-rw-rw-r--    1 pkg     pkg                       588 Feb  5 02:53 hello-world.spec
```

`$` **`rpm -qip ../SRPMS/hello-world-1.0-1.src.rpm`**
```
Name        : hello-world
Version     : 1.0
Release     : 1
Architecture: x86_64
Install Date: (not installed)
Group       : Unspecified
Size        : 629
License     : GPLv3
Signature   : (none)
Source RPM  : (none)
Build Date  : Mon Feb  5 02:53:10 2018
Build Host  : 5e828de159c9
Relocations : (not relocatable)
URL         : None-yet
Summary     : A simple hello world application
Description :
A simple hello world application
```

`$` **`rpm -qlvp ../RPMS/x86_64/hello-world-1.0-1.x86_64.rpm`**
```
-rwxr-xr-x    1 root    root                       41 Feb  5 02:53 /usr/bin/hello-world.sh
```

`$` **`rpm -qip ../RPMS/x86_64/hello-world-1.0-1.x86_64.rpm`**
```
Name        : hello-world
Version     : 1.0
Release     : 1
Architecture: x86_64
Install Date: (not installed)
Group       : Unspecified
Size        : 41
License     : GPLv3
Signature   : (none)
Source RPM  : hello-world-1.0-1.src.rpm
Build Date  : Mon Feb  5 02:53:10 2018
Build Host  : 5e828de159c9
Relocations : (not relocatable)
URL         : None-yet
Summary     : A simple hello world application
Description :
A simple hello world application
```

So now you have your package, you can install it and run your command !

`#` **`rpm -ivh ../RPMS/x86_64/hello-world-1.0-1.x86_64.rpm`**
```
Preparing...                          ################################# [100%]
Updating / installing...
   1:hello-world-1.0-1                ################################# [100%]
```

`$` **`hello-world.sh`**
```
Hello Packaging World
```

## Going one step further in package building

Estimated time: 15 minutes.

Well our "application" is really simple and doesn't really correspond to a real one. We're missing content (licensing file, man page, documentation) and our package is in fact wrong. Well you could say, it worked, it installed, the command runs, so what ? That's where `rpmlint` comes to the rescue:

`$` **`rpmlint ../RPMS/x86_64/hello-world-1.0-1.x86_64.rpm`**
```
hello-world.x86_64: W: invalid-url URL None-yet
hello-world.x86_64: E: no-binary
hello-world.x86_64: W: no-documentation
hello-world.x86_64: W: no-manual-page-for-binary hello-world.sh
1 packages and 0 specfiles checked; 1 errors, 4 warnings.
```
So indeed we do have problems to solve ;-)
The main one is that we created a x86_64 binary package whereas we do not have any binary in it. That's the default behaviour when nothing is specified in our spec file. So what we really would like to have is what is called a "noarch" package, a package which is independent from the processor architecture and could be installed similarly on i586, x86_64, arm64 or ia64 e.g. For that we need to add the following line to our spec file below the Requires line:

```
BuildArch:      noarch
```

Rebuild then the package and look at what changed.  Uninstall the previous one and install that new one and check again the program and the output of `rpmlint` to verify that the error indeed disappeared.

It's now time to solve our warnings. Fixing the URL is easy, just use a correct one pointing to your home page e.g. or something like http://www.none.net
Then you really have to create the missing documentation, and while it's not described explicitely the license as well. So do the following:

`$` **`cat > ../SOURCES/hello-world.sh.man << EOF`**
```
.\" Copyright (c) 2018 Bruno Cornec
.\"                                                                                                                                                                                                  
.\" This work is licensed under a Creative Commons 
.\" Attribution-ShareAlike 4.0 International License.
.\" https://creativecommons.org/licenses/by-sa/4.0/
.TH HELLO-WORLD.SH 1 
.SH NAME
hello-world.sh \- a tool to welcome you
.SH SYNOPSIS
.B hello-world.sh
.SH DESCRIPTION
.PP
.B hello-world.sh
displays a welcome message
.SH OPTIONS
.PP
hello-world.sh has no option
.SH DIAGNOSTICS
.B hello-world.sh
writes some output to the console
.SH "SEE ALSO"

.TP
See mailing list at http://www.none.net for technical support.
.SH AUTHORS
.BR
Bruno Cornec (lead-development) 
.I "bruno_at_hpe.com"
.
EOF
```

`$` **`wget https://www.gnu.org/licenses/gpl.txt`**

`$` **`mv gpl.txt ../SOURCES/LICENSE`**

And amend the spec file in order to use these documentation files:

```
--- hello-world.spec.old        2018-02-05 05:12:55.258477109 +0000
+++ hello-world.spec    2018-02-05 05:14:59.102468999 +0000
@@ -4,11 +4,14 @@
 Summary:        A simple hello world application
 
 License:        GPLv3
-URL:            None-yet
+URL:            http://www.none.net
 Source0:        hello-world.sh
+Source1:        hello-world.sh.man
+Source2:        LICENSE
 
 #BuildRequires:  
 Requires:       bash
+BuildArch:     noarch
 
 %description
 A simple hello world application
@@ -25,13 +28,18 @@
 rm -rf $RPM_BUILD_ROOT
 ##make_install
 mkdir -p $RPM_BUILD_ROOT/%{_bindir}
+mkdir -p $RPM_BUILD_ROOT/%{_mandir}/man1
 cp %{SOURCE0} $RPM_BUILD_ROOT/%{_bindir}
+cp %{SOURCE1} $RPM_BUILD_ROOT/%{_mandir}/man1/%{name}.sh.1
+nroff -man %{SOURCE1} > $RPM_BUILD_DIR/README
+cp %{SOURCE2} $RPM_BUILD_DIR
 
 
 %files
 %{_bindir}/%{name}.sh
+%{_mandir}/man1/%{name}.sh.1.gz
 
-##doc
+%doc LICENSE README
 
 %changelog
 * Sun Feb 04 2018 Bruno Cornec <pingouin@hpe.com> 1.0-1
```

You can use this content as an input file to the command `patch` in order to modify your content, or apply the modifications manually.

Rebuild again your package with `rpmbuild`. On the generated package, using the `-p` option of `rpm` check the content of your package and verify it with `rpmlint` as well to ensure you've solved all issues.

`$` **`rpm -qlp /home/pkg/rpmbuild/RPMS/noarch/hello-world-1.0-1.noarch.rpm`**
```
/usr/bin/hello-world.sh
/usr/share/doc/hello-world-1.0
/usr/share/doc/hello-world-1.0/LICENSE
/usr/share/doc/hello-world-1.0/README
/usr/share/man/man1/hello-world.sh.1.gz
```

`$` **`rpmlint /home/pkg/rpmbuild/RPMS/noarch/hello-world-1.0-1.noarch.rpm`**
```
1 packages and 0 specfiles checked; 0 errors, 0 warnings.
```

and now install it. Why does it not work as expected ?

If you're stuck here, feel free to raise your hand so your instructor can help you !

If you used this command and got that message:

`#` **`rpm -ivh /home/pkg/rpmbuild/RPMS/noarch/hello-world-1.0-1.noarch.rpm`**
```
Preparing...                          ################################# [100%]
        package hello-world-1.0-1.noarch is already installed
```

then, this is normal ;-) The package you just built has no obvious or distinctive difference with the one which is alread installed. However, you did change the specfile and rebuilt the package. So one way to solve this would be as before to first remove the previous package and then reinstall. That would work, but is cheating. What you really need to do is indicate to the RPM system that you changed the way you build thepackage. This is what the Release tag is made for. Each time you change your specfile, and want to install or distribute the resulting packages, then you need to increase the Release tag. So here replace the 1 by 2 in the spec file, rebuild and try again to install using the `-F` or `-U` option of the `rpm` command, not the `-i`.

Do not forget to update the changlog part of the spec file with a new entry !

As you can see, building a correct RPM Package is an iterative process that can take some time, even for a simple application like ours. Let's go a bit further now.

## Packages repositories

Estimated time: 10 minutes.

Of course, we can use the `rpm` command to install our package. But what abour `yum` ? How to share our package so others can also install it easily ? That's what we'll see just now !

To work correctly, yum needs to group the RPM metadata that you can see in the package using `rpm -qi` into central files that yum will use to determine how to install a given package and its dependencies. For that, you need to use the `createrepo` command, part of the eponym package if you don't have it installed:

`$` **`cd /home/pkg/rpmbuild/RPMS`**

`$` **`rm -rf x86_64`**

We remove the now old created binary package that we don't need.

`$` **`createrepo .`**
```
Spawning worker 0 with 1 pkgs
Spawning worker 1 with 1 pkgs
Spawning worker 2 with 1 pkgs
Spawning worker 3 with 0 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete
```

`$` **`ls -al repodata`**
```
total 28
-rw-rw-r-- 1 pkg pkg  425 Feb  6 21:46 20d9c30e0ee90aee9a4d53ebbbcfc06b39c6c8257cb12227835f9387aeedc4bb-filelists.xml.gz
-rw-rw-r-- 1 pkg pkg  952 Feb  6 21:46 4eca218d56d3ccb324c25a12ccc26b1685f517f6fbab64a555593873da5bf326-other.sqlite.bz2
-rw-rw-r-- 1 pkg pkg  820 Feb  6 21:46 7cb45c54e35d0489bc8aa0c9f6687308dac7a997aca924704bf84cfd04882420-primary.xml.gz
-rw-rw-r-- 1 pkg pkg  414 Feb  6 21:46 9960e20513631aa4db9c5c388aeeac64d1d7ecd7d24e72f96b0764b44a42e714-other.xml.gz
-rw-rw-r-- 1 pkg pkg 1231 Feb  6 21:46 c8d002c76177096b3b5cb3f052791a019fd24161da80e710b3f91ebe4c3ff73d-filelists.sqlite.bz2
-rw-rw-r-- 1 pkg pkg 2127 Feb  6 21:46 e330ace136cd50c90101a2019d8d77d4aea7077fffabbbaa2d13ecf5c0cf3fdc-primary.sqlite.bz2
-rw-rw-r-- 1 pkg pkg 2965 Feb  6 21:46 repomd.xml
```

`$` **`gzip -cd repodata/*-filelists.xml.gz`**
```
<?xml version="1.0" encoding="UTF-8"?>
<filelists xmlns="http://linux.duke.edu/metadata/filelists" packages="3">
<package pkgid="9058427c5fad93b0ad3f5d52e8b97a297ec0807691e463db34395fd35a2e661d" name="hello-world" arch="noarch">
  <version epoch="0" ver="1.0" rel="1"/>
  <file>/usr/bin/hello-world.sh</file>
  <file>/usr/share/doc/hello-world-1.0/LICENSE</file>
  <file>/usr/share/doc/hello-world-1.0/README</file>
  <file>/usr/share/man/man1/hello-world.sh.1.gz</file>
  <file type="dir">/usr/share/doc/hello-world-1.0</file>
</package>
<package pkgid="f3e1ed29f51db1b8bb77c244c0b49d0cd41022389f24bed920e3cdae92735e0a" name="hello-world" arch="noarch">
  <version epoch="0" ver="1.0" rel="2"/>
  <file>/usr/bin/hello-world.sh</file>
  <file>/usr/share/doc/hello-world-1.0/LICENSE</file>
  <file>/usr/share/doc/hello-world-1.0/README</file>
  <file>/usr/share/man/man1/hello-world.sh.1.gz</file>
  <file type="dir">/usr/share/doc/hello-world-1.0</file>
</package>
</filelists>
```

You can see that you have 2 packages referenced in your new repository, because you have made twice the build with different relaese tags.

So great we have a repo, but now we'd like to test and use it. We'll do it on our own system for now. So we need to add a new repo:

<!--
`#` **`rpm -e hello-world`**
-->

`$` **`cat > /etc/yum.repos.d/hello.repo << EOF`**
```
[hello]
name=Hello repo
baseurl=file:///home/pkg/rpmbuild/RPMS
gpgcheck=0
```

`#` **`yum install hello-world`**
```
Loaded plugins: fastestmirror, ovl
hello                                                      | 2.9 kB  00:00:00     
hello/primary_db                                           | 1.8 kB  00:00:00     
Loading mirror speeds from cached hostfile
 * base: repos.dfw.quadranet.com
 * extras: repos-lax.psychz.net
 * updates: mirror.clarkson.edu
Resolving Dependencies
--> Running transaction check
---> Package hello-world.noarch 0:1.0-2 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=============================================================================
 Package              Arch            Version           Repository      Size
=============================================================================
Installing:
 hello-world          noarch          1.0-2             hello           15 k

Transaction Summary
=============================================================================
Install  1 Package

Total download size: 15 k
Installed size: 35 k
Is this ok [y/d/N]: y
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
  Installing : hello-world-1.0-2.noarch                                  1/1 
  Verifying  : hello-world-1.0-2.noarch                                  1/1 

Installed:
  hello-world.noarch 0:1.0-2                                                                                                                                                                         

Complete!
```

All that is nice and fine, but it would be better if it could be working also from another system. For that instead of using the file:// protocol in the configuration file, we could use http:// or ftp:// instead. As ftp is very easy to setup, let's try to do it again with his after you removed again your package ;-)

`#` **`yum install vsftpd`**

`#` **`systemctl start vsftpd`**

`#` **`mv /home/pkg/rpmbuild/RPMS /var/ftp`**

`$` **`cat > /etc/yum.repos.d/hello.repo << EOF`**
```
[hello]
name=Hello repo
baseurl=ftp://localhost/RPMS
gpgcheck=0
```

`#` **`yum install hello-world`**
```
Loaded plugins: fastestmirror, ovl
hello                                                                                                                                                                         | 2.9 kB  00:00:00     
Loading mirror speeds from cached hostfile
 * base: mirror.rackspace.com
 * extras: pubmirrors.dal.corespace.com
 * updates: repo1.dal.innoscale.net
Resolving Dependencies
--> Running transaction check
---> Package hello-world.noarch 0:1.0-2 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=====================================================================================================================================================================================================
 Package                                            Arch                                          Version                                         Repository                                    Size
=====================================================================================================================================================================================================
Installing:
 hello-world                                        noarch                                        1.0-2                                           hello                                         15 k

Transaction Summary
=====================================================================================================================================================================================================
Install  1 Package

Total download size: 15 k
Installed size: 35 k
Is this ok [y/d/N]: **y**
Downloading packages:
hello-world-1.0-2.noarch.rpm                                                                                                                                                  |  15 kB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
  Installing : hello-world-1.0-2.noarch                                                                                                                                                          1/1 
  Verifying  : hello-world-1.0-2.noarch                                                                                                                                                          1/1 

Installed:
  hello-world.noarch 0:1.0-2                                                                                                                                                                         

Complete!
```

There is much more to discover around the packages, for example how to GnuPG sign them, and have GnuPG signed repositories as well to improve security.

This is the end of this lab for now, we hope you enjoyed it.

Github issues and pull requests to improve this lab are welcome.
