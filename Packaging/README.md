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
 2. A correspondance of commands between RPM and DEB packages manipulation at https://help.ubuntu.com/community/SwitchingToUbuntu/FromLinux/RedHatEnterpriseLinuxAndFedora

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

Finally the best practice to work on packages is to **work as a normal user**, not as root. Building as root, if you have errors in your build configuration may lead to an unusable system, so it's important (and sure in general) to just adopt the minimum set of priviledges required for the operations we do. Of course, installing the package, once built, will require root priviledges as seen previously, but everything else should be performed as a normal user. You may open 2 terminals one as a user pkg (once created with the below commands), the other one as root to ease operations.

So create your normal use account and switch to it:

`#` **`useradd pkg`**

`#` **`passwd pkg`**

`#` **`su - pkg`**

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

`#` **`apt-get update`**

`#` **`apt-get install wget patch dpkg-dev make debian-builder dh-make fakeroot diffutils sudo vim`**

# Managing RPM Packages
Estimated time: 15 minutes.

In order to be able to manage packages, the easiest approach is to use an existing one, before creating your own. Of course, if you're already very familiar with package usage on Linux, you may skip that part to go to the next one. The management of package will consists here in searching for them, choosing them, installing them, removing them, upgrading them, ... using both the **`yum`** and the **`rpm`** commands.

Each RPM based distribution maintains a repository of packages from where you can search and install additional components on your distribution. For example, search and install the nano editor on your system:

`$` **`nano`**
```
bash: nano: command not found
```

`$` **`yum search nano`**
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

`$` **`yum info nano`**
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

`$` **`nano`**

Type:

`#` **`yum remove nano`**

to get rid of this package.

**`yum`** is very handy for package management using repositories. The repositories used are declared using configuration files hosted under the **`/etc/yum.repos.d`** directory. You can extend the number of repositories considered when managing packages by adding configuration files there, and of course, the corresponding set of packages and indexes at the URL pointed to into these files.

You can also search for packages using key words, and not package names when looking for a feature. Try to run:

`$` **`yum search editor`**

**`yum`** is an upper layer on top of the **`rpm`** command which does the job of package management, while the former does the job of repositories management. Let's understand how that command works:

`$` **`wget http://mirror.centos.org/centos/7/os/x86_64/Packages/nano-2.3.1-10.el7.x86_64.rpm`**
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
`$` **`ls -al nano-2.3.1-10.el7.x86_64.rpm`**
```
-rw-rw-r-- 1 pkg pkg 450136 Jul  4  2014 nano-2.3.1-10.el7.x86_64.rpm
```

`$` **`rpm -qip nano-2.3.1-10.el7.x86_64.rpm`**
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

Looks probably familiar after the **`yum info`** one, but you see you can get more details here.

`$` **`rpm -qlp nano-2.3.1-10.el7.x86_64.rpm`**
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

`#` **`rpm -ivh /home/pkg/nano-2.3.1-10.el7.x86_64.rpm`**
```
Preparing...                          ################################# [100%]
Updating / installing...
   1:nano-2.3.1-10.el7                ################################# [100%]
```

`$` **`nano`**

CentOS 7 is a Long Time Support type of distribution. Which means that it tends to provide stable software at time of release, and do not update them to the latest versions, as long as it's not required (security issues). For example, the `nano` package upstream is much more recent as you can check at https://www.nano-editor.org/download.php . Some people have even made updated CentOS 7 packages for nano, that we can use to update our distribution:

`$` **`wget http://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64//nano-2.7.4-3.gf.el7.x86_64.rpm`**
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

`$` **`rpm -q nano`**

`$` **`nano --version`**

Now remove the package:

`#` **`rpm -e nano`**

`$` **`nano --version`**

And start again, but this time using repositories and new commands ! People have created an additional repository containing additional CentOS 7 packages as well as updates for the distribution (called often backports). They also have created a package which prepare the repository setup on your distribution to use `yum` flowalessly afterwards. Let's look at that: 

`#` **`rpm -Uvh http://mirror.ghettoforge.org/distributions/gf/el/7/gf/x86_64/gf-release-7-10.gf.el7.noarch.rpm`**

`$` **`rpm -ql gf-release`**

`#` **`cat /etc/yum.repos.d/gf.repo`**

`#` **`yum --enablerepo=gf-plus install nano`**

`$` **`nano --version`**

Clean up this setup:

`#` **`rpm -e nano gf-release`**

Look at the man pages for `yum` and `rpm` to learn more about them.

# Building RPM Packages
## The first package
Estimated time: 15 minutes.

The RPM packages creation occurs through the usage of a spec file. So, you first have to create one in order to build your package.
For that we will use the `rpmdev-newspec` command to generate the template we need for our test executable. First create the "application" we want to package:

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

We used the %{_bindir} to describe the place to install the binary. This a rpm macro that we're just using. If you want to have an idea of rpm macros, issue the following command:

`$` **`rpm --showrc`**

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

## Going one step further in RPM package building

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
.I "pingouin_at_hpe.com"
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

and now install it. Why doesn't it work as expected ?

If you're stuck here, feel free to raise your hand so your instructor can help you !

If you used this command and got that message:

`#` **`rpm -ivh /home/pkg/rpmbuild/RPMS/noarch/hello-world-1.0-1.noarch.rpm`**
```
Preparing...                          ################################# [100%]
        package hello-world-1.0-1.noarch is already installed
```

then, this is normal ;-) The package you just built has no obvious or distinctive difference with the one which is alread installed. However, you did change the specfile and rebuilt the package. So one way to solve this would be as before to first remove the previous package and then reinstall. That would work, but is cheating. What you really need to do is indicate to the RPM system that you changed the way you build the package. This is what the Release tag is made for. Each time you change your specfile, and want to install or distribute the resulting packages, then you need to increase the Release tag. So here replace the 1 by 2 in the spec file, rebuild and try again to install using the `-F` or `-U` option of the `rpm` command, not the `-i`.

Do not forget to update the changlog part of the spec file with a new entry !

As you can see, building a correct RPM Package is an iterative process that can take some time, even for a simple application like ours. Let's go a bit further now.

<!-- TODO: Make a tar bal to store files -->

## Packages repositories

Estimated time: 10 minutes.

Of course, we can use the `rpm` command to install our package. But what about `yum` ? How to share our package so others can also install it easily ? That's what we'll see just now !

To work correctly, `yum` needs to group the RPM metadata that you can see in the package using `rpm -qi` into central files that `yum` will use to determine how to install a given package and its dependencies. For that, you need to use the `createrepo` command, part of the eponym package if you don't have it installed:

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

`#` **`/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf &`**

#
#Or if you can use systemd
#
#`#` **`systemctl start vsftpd`**

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

There is much more to discover around the RPM packages, for example how to GnuPG sign them, and have GnuPG signed repositories as well to improve security.

# Managing DEB Packages
Estimated time: 15 minutes.

In order to be able to manage packages, the easiest approach is to use an existing one, before creating your own. Of course, if you're already very familiar with package usage on Linux, you may skip that part to go to the next one. The management of package will consists here in searching for them, choosing them, installing them, removing them, upgrading them, ... using both the **`apt`** and the **`dpkg`** commands.

Each DEB based distribution maintains a repository of packages from where you can search and install additional components on your distribution. For example, search and install the nano editor on your system:

`$` **`nano`**
`bash: nano: command not found`

`$` **`apt-cache search nano`**
```
science-nanoscale-physics - Debian Science Nanoscale Physics packages
science-nanoscale-physics-dev - Debian Science Nanoscale Physics development packages
libfast5-dev - library for reading Oxford Nanopore Fast5 files -- headers
python-fast5 - library for reading Oxford Nanopore Fast5 files -- Python 2
python3-fast5 - library for reading Oxford Nanopore Fast5 files -- Python 3
kiki-the-nano-bot - 3D puzzle game, mixing Sokoban and Kula-World
kiki-the-nano-bot-data - Kiki the nano bot - game data
libnanomsg-raw-perl - low-level interface to nanomsg for Perl
libnanoxml2-java - small XML parser for Java
libnanoxml2-java-doc - documentation for libnanoxml2-java
libtime-clock-perl - twenty-four hour clock object with nanosecond precision
nano - small, friendly text editor inspired by Pico
nano-tiny - small, friendly text editor inspired by Pico - tiny build
nanoblogger - Small weblog engine for the command line
nanoblogger-extra - Nanoblogger plugins
nanoc - static site generator written in Ruby
nanoc-doc - static site generator written in Ruby - documentation
libnanomsg-dev - nanomsg development files
libnanomsg4 - high-performance implementation of scalability libraries
nanomsg-utils - nanomsg utilities
nanopolish - consensus caller for nanopore sequencing data
osmocom-ipaccess-utils - Command line utilities for ip.access nanoBTS
openmx - package for nano-scale material simulations
openmx-data - package for nano-scale material simulations (data)
poretools - toolkit for nanopore nucleotide sequencing data
poretools-data - toolkit for nanopore nucleotide sequencing data -- sample datasets
python-nanomsg - Python wrapper for nanomsg (Python 2)
python3-nanomsg - Python wrapper for nanomsg (Python 3)
ruby-nanotest - Exteremely minimal test framework
```

`$` **`apt-cache show nano`**
```
Package: nano
Version: 2.7.4-1
Installed-Size: 2043
Maintainer: Jordi Mallach <jordi@debian.org>
Architecture: amd64
Replaces: pico
Provides: editor
Depends: libc6 (>= 2.14), libncursesw5 (>= 6), libtinfo5 (>= 6), zlib1g (>= 1:1.1.4)
Suggests: spell
Conflicts: pico
Description: small, friendly text editor inspired by Pico
Description-md5: 04397a7cc45e02bc3a9900a7fbed769c
Homepage: https://www.nano-editor.org/
Tag: implemented-in::c, interface::text-mode, role::program, scope::utility,
 suite::gnu, uitoolkit::ncurses, use::editing, works-with::text
Section: editors
Priority: important
Filename: pool/main/n/nano/nano_2.7.4-1_amd64.deb
Size: 484790
MD5sum: 161a45ba3787383f8348f985b4c3d3e9
SHA256: 9181ebcf0fb5c302bd53150531b6609394a030d1be06f376275d690c70964d59
```

`#` **`apt-get install nano`**
```
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Suggested packages:
  spell
The following NEW packages will be installed:
  nano
0 upgraded, 1 newly installed, 0 to remove and 4 not upgraded.
Need to get 485 kB of archives.
After this operation, 2092 kB of additional disk space will be used.
Get:1 http://deb.debian.org/debian stretch/main amd64 nano amd64 2.7.4-1 [485 kB]
Fetched 485 kB in 0s (1705 kB/s)
debconf: delaying package configuration, since apt-utils is not installed
Selecting previously unselected package nano.
(Reading database ... 27056 files and directories currently installed.)
Preparing to unpack .../nano_2.7.4-1_amd64.deb ...
Unpacking nano (2.7.4-1) ...
Setting up nano (2.7.4-1) ...
update-alternatives: using /bin/nano to provide /usr/bin/editor (editor) in auto mode
update-alternatives: using /bin/nano to provide /usr/bin/pico (pico) in auto mode
Processing triggers for man-db (2.7.6.1-2) ...
```

`$` **`nano`**

Type:

`#` **`apt-get purge nano`**
```
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following packages will be REMOVED:
  nano
0 upgraded, 0 newly installed, 1 to remove and 4 not upgraded.
After this operation, 2092 kB disk space will be freed.
Do you want to continue? [Y/n] **Y**
(Reading database ... 27156 files and directories currently installed.)
Removing nano (2.7.4-1) ...
Processing triggers for man-db (2.7.6.1-2) ...
(Reading database ... 27057 files and directories currently installed.)
Purging configuration files for nano (2.7.4-1) ...
```

to get rid of this package.

**`apt`** is very handy for package management using repositories. The repositories used are declared using configuration files hosted under the **`/etc/apt`** directory. You can extend the number of repositories considered when managing packages by adding configuration files in `sources.list` or the `sources.list.d` directory, and of course, the corresponding set of packages and indexes at the URL pointed to into these files.

You can also search for packages using key words, and not package names when looking for a feature. Try to run:

`$` **`apt-cache search editor`**

**`apt`** does the job of repositories management while the **`dpkg`** command does the job of package management. Let's understand how that command works:

`$` **`wget ftp://ftp.project-builder.org/debian/9/libprojectbuilder-perl_0.14.6-1_all.deb`**
```
--2018-02-09 06:26:15--  ftp://ftp.project-builder.org/debian/9/libprojectbuilder-perl_0.14.6-1_all.deb
           => 'libprojectbuilder-perl_0.14.6-1_all.deb'
Resolving ftp.project-builder.org (ftp.project-builder.org)... 185.170.48.239
Connecting to ftp.project-builder.org (ftp.project-builder.org)|185.170.48.239|:21... connected.
Logging in as anonymous ... Logged in!
==> SYST ... done.    ==> PWD ... done.
==> TYPE I ... done.  ==> CWD (1) /debian/9 ... done.
==> SIZE libprojectbuilder-perl_0.14.6-1_all.deb ... 123606
==> PASV ... done.    ==> RETR libprojectbuilder-perl_0.14.6-1_all.deb ... done.
Length: 123606 (121K) (unauthoritative)

libprojectbuilder-perl_0.14.6-1_all.deb           100%[==========================================================================================================>] 120.71K   192KB/s    in 0.6s    

2018-02-09 06:26:18 (192 KB/s) - 'libprojectbuilder-perl_0.14.6-1_all.deb' saved [123606]

```
`$` **`ls -al libprojectbuilder-perl_0.14.6-1_all.deb `**
```
-rw-r--r-- 1 pkg pkg 123606 Feb  9 06:26 libprojectbuilder-perl_0.14.6-1_all.deb
```

`$` **`dpkg --info libprojectbuilder-perl_0.14.6-1_all.deb`**
```
 new debian package, version 2.0.
 size 123606 bytes: control archive=1345 bytes.
      16 bytes,     1 lines      conffiles            
     604 bytes,    15 lines      control              
    1946 bytes,    26 lines      md5sums              
 Package: libprojectbuilder-perl
 Version: 0.14.6-1
 Architecture: all
 Maintainer: Bruno Cornec <bruno@project-builder.org>
 Installed-Size: 433
 Depends: perl (>= 5.8.4)
 Suggests: liblinux-sysinfo-perl, libsys-cpu-perl
 Section: perl
 Priority: optional
 Homepage: http://trac.project-builder.org
 Description: Perl module providing multi-OSes (Linux/Solaris/...) Continuous Packaging
  ProjectBuilder is a perl module providing set of functions
  to help develop packages for projects and deal
  with different Operating systems (Linux distributions, Solaris, ...).
  It implements a Continuous Packaging approach.
```

`$` **`dpkg --contents libprojectbuilder-perl_0.14.6-1_all.deb`**
```
drwxr-xr-x root/root         0 2017-09-05 22:00 ./
drwxr-xr-x root/root         0 2017-09-05 22:00 ./etc/
drwxr-xr-x root/root         0 2017-09-05 22:00 ./etc/pb/
-rw-r--r-- root/root     90775 2017-09-05 22:00 ./etc/pb/pb.conf
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/bin/
-rwxr-xr-x root/root      4636 2017-09-05 22:00 ./usr/bin/pbdistrocheck
-rwxr-xr-x root/root      3179 2017-09-05 22:00 ./usr/bin/pbgetparam
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/doc/
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/doc/libprojectbuilder-perl/
-rw-r--r-- root/root      9719 2017-09-05 22:00 ./usr/share/doc/libprojectbuilder-perl/changelog.Debian.gz
-rw-r--r-- root/root     27275 2017-09-05 22:00 ./usr/share/doc/libprojectbuilder-perl/changelog.gz
-rw-r--r-- root/root      1125 2017-09-05 22:00 ./usr/share/doc/libprojectbuilder-perl/copyright
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/man/
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/man/man1/
-rw-r--r-- root/root      2110 2017-09-05 22:00 ./usr/share/man/man1/pbdistrocheck.1p.gz
-rw-r--r-- root/root      1994 2017-09-05 22:00 ./usr/share/man/man1/pbgetparam.1p.gz
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/man/man3/
-rw-r--r-- root/root      3755 2017-09-05 22:00 ./usr/share/man/man3/ProjectBuilder::Base.3pm.gz
[...]
-rw-r--r-- root/root      1722 2017-09-05 22:00 ./usr/share/man/man3/ProjectBuilder::VE.3pm.gz
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/man/man5/
-rw-r--r-- root/root     12041 2017-09-05 22:00 ./usr/share/man/man5/pb.conf.5.gz
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/pb/
-rw-r--r-- root/root     89954 2017-09-05 22:00 ./usr/share/pb/pb.conf
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/perl5/
drwxr-xr-x root/root         0 2017-09-05 22:00 ./usr/share/perl5/ProjectBuilder/
-rw-r--r-- root/root     16272 2016-07-23 13:57 ./usr/share/perl5/ProjectBuilder/Base.pm
[...]
-rw-r--r-- root/root       754 2017-09-05 22:00 ./usr/share/perl5/ProjectBuilder/Version.pm
```

So you can get the list of all files that will be installed on your system by `dpkg` that way. Let's install the package, using `dpkg` this time:

`#` **`dpkg -i libprojectbuilder-perl_0.14.6-1_all.deb`**
```
Selecting previously unselected package libprojectbuilder-perl.
(Reading database ... 27056 files and directories currently installed.)
Preparing to unpack libprojectbuilder-perl_0.14.6-1_all.deb ...
Unpacking libprojectbuilder-perl (0.14.6-1) ...
Setting up libprojectbuilder-perl (0.14.6-1) ...
Processing triggers for man-db (2.7.6.1-2) ...
```

`$` **`pbdistrocheck`**
```
Project-Builder tuple:
OS:     linux
Name:   debian
Ver:    9
Arch:   x86_64
Type:   deb
Family: du
Suffix: .debian9
Update: sudo /usr/bin/apt-get update; sudo /usr/bin/env DEBIAN_FRONTEND="noninteractive" /usr/bin/apt-get --quiet -y --force-yes dist-upgrade
Install:        sudo /usr/bin/apt-get update ; sudo /usr/bin/env DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -y --allow-unauthenticated install
```

Check you have the package in your database:

`$` **`dpkg -l libprojectbuilder-perl`**
```
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                                        Version                    Architecture               Description
+++-===========================================-==========================-==========================-===========================================================================================
ii  libprojectbuilder-perl                      0.14.6-1                   all                        Perl module providing multi-OSes (Linux/Solaris/...) Continuous Packaging
```

Now remove the package:

`#` **`dpkg -r libprojectbuilder-perl`**

`$` **`pbdistrocheck`**
```
bash: /usr/bin/pbdistrocheck: No such file or directory
```

Look at the man pages for `dpkg` and `apt` to learn more about them.

# Building DEB Packages
## The first package
Estimated time: 15 minutes.

The DEB packages creation occurs through the usage of a debian directory. So, you first have to create one in order to build your package.
For that we will use the `dh_make` command to generate the template content we need for our test executable. First create the "application" we want to package:

`$` **`mkdir hello-world-1.0`**

`$` **`cd hello-world-1.0`**

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

Then create a tar file of the content for our package:

`$` **`cd ..`**

`$` **`tar cvfz hello-world-1.0.tar.gz hello-world-1.0`**
```
hello-world-1.0/
hello-world-1.0/hello-world.sh
```

Then create the template for our package:

`$` **`cat >> /home/pkg/.bashrc << EOF`**
```
DEBEMAIL="bruno@project-builder.org"
DEBFULLNAME="Bruno Cornec"
export DEBEMAIL DEBFULLNAME
EOF
```

`$` **`. /home/pkg/.bashrc`**

`$` **`cd hello-world-1.0`**

`$` **`dh_make -f ../hello-world-1.0.tar.gz`**
```
Type of package: (single, indep, library, python)
[s/i/l/p]? **s**
Email-Address       : bruno@project-builder.org
License             : blank
Package Name        : hello-world
Maintainer Name     : Bruno Cornec
Version             : 1.0
Package Type        : single
Date                : Fri, 09 Feb 2018 07:05:25 +0000
Are the details correct? [Y/n/q] **y**
Currently there is not top level Makefile. This mayrequire additional tuning
Done. Please edit the files in the debian/ subdirectory now.

```

Look at the content of the `debian` directory created and modify it so it corresponds to the following:

`$` **`ls -al debian`**
```
total 104
drwxr-xr-x 3 pkg pkg  4096 Feb  9 07:06 .
drwxr-xr-x 3 pkg pkg  4096 Feb  9 07:06 ..
-rw-r--r-- 1 pkg pkg   193 Feb  9 07:06 README.Debian
-rw-r--r-- 1 pkg pkg   278 Feb  9 07:06 README.source
-rw-r--r-- 1 pkg pkg   199 Feb  9 07:06 changelog
-rw-r--r-- 1 pkg pkg     2 Feb  9 07:06 compat
-rw-r--r-- 1 pkg pkg   538 Feb  9 07:06 control
-rw-r--r-- 1 pkg pkg  1692 Feb  9 07:06 copyright
-rw-r--r-- 1 pkg pkg    28 Feb  9 07:06 hello-world-docs.docs
-rw-r--r-- 1 pkg pkg   143 Feb  9 07:06 hello-world.cron.d.ex
-rw-r--r-- 1 pkg pkg   247 Feb  9 07:06 hello-world.default.ex
-rw-r--r-- 1 pkg pkg   559 Feb  9 07:06 hello-world.doc-base.EX
-rw-r--r-- 1 pkg pkg  1662 Feb  9 07:06 manpage.1.ex
-rw-r--r-- 1 pkg pkg  4670 Feb  9 07:06 manpage.sgml.ex
-rw-r--r-- 1 pkg pkg 11029 Feb  9 07:06 manpage.xml.ex
-rw-r--r-- 1 pkg pkg   138 Feb  9 07:06 menu.ex
-rw-r--r-- 1 pkg pkg   962 Feb  9 07:06 postinst.ex
-rw-r--r-- 1 pkg pkg   935 Feb  9 07:06 postrm.ex
-rw-r--r-- 1 pkg pkg   695 Feb  9 07:06 preinst.ex
-rw-r--r-- 1 pkg pkg   882 Feb  9 07:06 prerm.ex
-rwxr-xr-x 1 pkg pkg   677 Feb  9 07:06 rules
drwxr-xr-x 2 pkg pkg  4096 Feb  9 07:06 source
-rw-r--r-- 1 pkg pkg  1185 Feb  9 07:06 watch.ex
```

Now try to build your first package with:

`$` **`dpkg-buildpackage -us -uc`**
```
dpkg-buildpackage: info: source package hello-world
dpkg-buildpackage: info: source version 1.0-1
dpkg-buildpackage: info: source distribution unstable
dpkg-buildpackage: info: source changed by Bruno Cornec <bruno@project-builder.org>
dpkg-buildpackage: info: host architecture amd64
 dpkg-source --before-build hello-world-1.0
 fakeroot debian/rules clean
dh clean
   dh_testdir
   dh_auto_clean
   dh_clean
 dpkg-source -b hello-world-1.0
dpkg-source: info: using source format '3.0 (quilt)'
dpkg-source: info: building hello-world using existing ./hello-world_1.0.orig.tar.gz
dpkg-source: info: building hello-world in hello-world_1.0-1.debian.tar.xz
dpkg-source: info: building hello-world in hello-world_1.0-1.dsc
 debian/rules build
dh build
   dh_testdir
   dh_update_autotools_config
   dh_auto_configure
   dh_auto_build
   dh_auto_test
   create-stamp debian/debhelper-build-stamp
 fakeroot debian/rules binary
dh binary
   create-stamp debian/debhelper-build-stamp
   dh_testroot
   dh_prep
   dh_auto_install
   dh_installdocs
   dh_installchangelogs
   dh_perl
   dh_link
   dh_strip_nondeterminism
   dh_compress
   dh_fixperms
   dh_strip
   dh_makeshlibs
   dh_shlibdeps
   dh_installdeb
   dh_gencontrol
dpkg-gencontrol: warning: Depends field of package hello-world: unknown substitution variable ${shlibs:Depends}
   dh_md5sums
   dh_builddeb
dpkg-deb: building package 'hello-world' in '../hello-world_1.0-1_amd64.deb'.
 dpkg-genbuildinfo
 dpkg-genchanges  >../hello-world_1.0-1_amd64.changes
dpkg-genchanges: info: including full source code in upload
 dpkg-source --after-build hello-world-1.0
dpkg-buildpackage: info: full upload (original source is included)
```

So this works ! Hey, that's Debian ;-) 

But of course, you don't really get what you want:

`$` **`ls -l ..`**
```
total 180
drwxr-xr-x 2 pkg    4096 Feb  9 06:20 .nano
drwxr-xr-x 4 root   4096 Feb  9 06:20 ..
-rw-r--r-- 1 pkg  123606 Feb  9 06:26 libprojectbuilder-perl_0.14.6-1_all.deb
-rw-r--r-- 1 pkg     199 Feb  9 07:02 hello-world_1.0.orig.tar.gz
-rw-r--r-- 1 pkg     199 Feb  9 07:02 hello-world-1.0.tar.gz
-rw-r--r-- 1 pkg      92 Feb  9 07:04 .bashrc
drwxr-xr-x 3 pkg    4096 Feb  9 07:06 hello-world-1.0
-rw-r--r-- 1 pkg    7832 Feb  9 07:10 hello-world_1.0-1.debian.tar.xz
-rw-r--r-- 1 pkg     841 Feb  9 07:10 hello-world_1.0-1.dsc
-rw-r--r-- 1 pkg    2202 Feb  9 07:10 hello-world_1.0-1_amd64.deb
-rw-r--r-- 1 pkg    4575 Feb  9 07:10 hello-world_1.0-1_amd64.buildinfo
drwxr-xr-x 4 root   4096 Feb  9 07:10 .
-rw-r--r-- 1 pkg    1811 Feb  9 07:10 hello-world_1.0-1_amd64.changes
```
You now need to understand what is wrong and fix it !

So one package has been created, called the binary package and other files alongside corresponding to source information. These last ones contain everything you need to rebuild the package with the source tar file and thus can be provided to another team in order to obtain the same binary package you got, providing the environment is similar.

A best practice here is also to place the content of the `debian` directory under a Version Control System such as git or subversion.

By default, the package created is architecture dependent, which s not the case of our program which is a script. 

`$` **`dpkg --contents ../hello-world_1.0-1_amd64.deb`**
```
drwxr-xr-x root/root         0 2018-02-09 07:05 ./
drwxr-xr-x root/root         0 2018-02-09 07:05 ./usr/
drwxr-xr-x root/root         0 2018-02-09 07:05 ./usr/share/
drwxr-xr-x root/root         0 2018-02-09 07:05 ./usr/share/doc/
drwxr-xr-x root/root         0 2018-02-09 07:05 ./usr/share/doc/hello-world/
-rw-r--r-- root/root       193 2018-02-09 07:05 ./usr/share/doc/hello-world/README.Debian
-rw-r--r-- root/root       182 2018-02-09 07:05 ./usr/share/doc/hello-world/changelog.Debian.gz
-rw-r--r-- root/root      1692 2018-02-09 07:05 ./usr/share/doc/hello-world/copyright
```

Ok, so the package doesn't contain what we need (no binary in particular)

`$` **`dpkg --info ../hello-world_1.0-1_amd64.deb`**
```
 new debian package, version 2.0.
 size 2202 bytes: control archive=498 bytes.
     311 bytes,    10 lines      control              
     224 bytes,     3 lines      md5sums              
 Package: hello-world
 Version: 1.0-1
 Architecture: amd64
 Maintainer: Bruno Cornec <bruno@project-builder.org>
 Installed-Size: 10
 Section: unknown
 Priority: optional
 Homepage: <insert the upstream URL, if relevant>
 Description: <insert up to 60 chars description>
  <insert long description, indented with spaces>
```

And the metadata are not in a better shape either ! So you'll have to go into the `debian` subdirectory and edit all the files needed to make modifications appropriately.

`$` **`cd debian`**

`$` **`rm -f README.* hello-world-docs.docs`**

`$` **`vi changelog control files rules`**

In these files modify the zones appearing as comments with appropriate content.

`$` **`cat changelog`**
```
hello-world (1.0-1) unstable; urgency=medium

  * Initial release

 -- Bruno Cornec <bruno@project-builder.org>  Fri, 09 Feb 2018 07:05:25 +0000
```

`$` **`cat control`**
```
Source: hello-world
Section: **doc**
Priority: optional
Maintainer: Bruno Cornec <bruno@project-builder.org>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.8
Homepage: **http://www.none.org**
#Vcs-Git: https://anonscm.debian.org/collab-maint/hello-world.git
#Vcs-Browser: https://anonscm.debian.org/cgit/collab-maint/hello-world.git

Package: hello-world
Architecture: **all**
Depends: ${shlibs:Depends}, ${misc:Depends}**, bash**
Description: **Say hello world for packagers
 Say hello world for packagers**
```

Build again the package now the modifications have been made:

`$` **`cd .. ; dpkg-buildpackage -us -uc`**

And check again data and metadata. Iterate up to the point you're happy with the result.

As you still don't have the script, it's because the call for installation planned by default is `make install`. However, we don't have a Makefile ! So create one as such:

`#` **`cat Makefile`**
```
install: hello-world.sh
        install -m 755 -d $(DESTDIR)/usr/bin
        install -m 755 hello-world.sh $(DESTDIR)/usr/bin
```

And these commands could also be useful:

`#` **`tar cvfz hello-world-1.0.tar.gz --exclude debian hello-world-1.0`**

`#` **`cp hello-world-1.0.tar.gz hello-world_1.0.orig.tar.gz`**

Finally you should get:

`$` **`dpkg --contents ../hello-world_1.0-1_amd64.deb`**
```
drwxr-xr-x root/root         0 2018-02-09 07:05 ./
drwxr-xr-x root/root         0 2018-02-09 07:05 ./usr/
drwxr-xr-x root/root         0 2018-02-09 07:05 ./usr/bin/
-rwxr-xr-x root/root        41 2018-02-09 07:05 ./usr/bin/hello-world.sh
drwxr-xr-x root/root         0 2018-02-09 07:05 ./usr/share/
drwxr-xr-x root/root         0 2018-02-09 07:05 ./usr/share/doc/
drwxr-xr-x root/root         0 2018-02-09 07:05 ./usr/share/doc/hello-world/
-rw-r--r-- root/root       146 2018-02-09 07:05 ./usr/share/doc/hello-world/changelog.Debian.gz
-rw-r--r-- root/root      1692 2018-02-09 07:05 ./usr/share/doc/hello-world/copyright
```

Now you can install your deb package:

`#` **`dpkg -i ../hello-world_1.0-1_all.deb`**
```
Selecting previously unselected package hello-world.
(Reading database ... 28868 files and directories currently installed.)
Preparing to unpack ../hello-world_1.0-1_all.deb ...
Unpacking hello-world (1.0-1) ...
Setting up hello-world (1.0-1) ...
```

`$` **`hello-world.sh`**
```
Hello Packaging World
```

## Going one step further in deb package building

Estimated time: 15 minutes.

Well our "application" is really simple and doesn't really correspond to a real one. We're missing correct content (licensing file, man page, documentation) and our package is in fact wrong. Well you could say, it worked, it installed, the command runs, so what ? That's where `lintian` comes to the rescue:

`$` **`lintian ../hello-world_1.0-1_all.deb`**
```
W: hello-world: new-package-should-close-itp-bug
E: hello-world: helper-templates-in-copyright
W: hello-world: copyright-has-url-from-dh_make-boilerplate
E: hello-world: copyright-contains-dh_make-todo-boilerplate
E: hello-world: description-synopsis-is-duplicated
E: hello-world: depends-on-essential-package-without-using-version depends: bash
W: hello-world: script-with-language-extension usr/bin/hello-world.sh
W: hello-world: binary-without-manpage usr/bin/hello-world.sh
```
So indeed we do have problems to solve ;-)

<!--
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
```

`$` **`ls -al repodata`**
```
```

`$` **`gzip -cd repodata/*-filelists.xml.gz`**
```
```

You can see that you have 2 packages referenced in your new repository, because you have made twice the build with different relaese tags.

So great we have a repo, but now we'd like to test and use it. We'll do it on our own system for now. So we need to add a new repo:

`$` **`cat > /etc/yum.repos.d/hello.repo << EOF`**
```
[hello]
name=Hello repo
baseurl=file:///home/pkg/rpmbuild/RPMS
gpgcheck=0
```

`#` **`yum install hello-world`**
```
```

All that is nice and fine, but it would be better if it could be working also from another system. For that instead of using the file:// protocol in the configuration file, we could use http:// or ftp:// instead. As ftp is very easy to setup, let's try to do it again with his after you removed again your package ;-)

`#` **`yum install vsftpd`**

`#` **`systemctl start vsftpd`**

`#` **`mv /home/pkg/rpmbuild/RPMS /var/ftp`**

`$` **`cat > /etc/yum.repos.d/hello.repo << EOF`**
```
```

`#` **`yum install hello-world`**
```
```

There is much more to discover around the packages, for example how to GnuPG sign them, and have GnuPG signed repositories as well to improve security.
-->

This is the end of this lab for now, we hope you enjoyed it.

Github issues and pull requests to improve this lab are welcome.
