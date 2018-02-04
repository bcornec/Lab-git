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

Commands to be executed as root user are prefixed with a `#` prompt, while commands to be executed as a normal user are prefixed with the `$` prompt.

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

`#` **`yum install wget make patch rpm-build diffutils`**

### Debian and Ubuntu installation

If you work on a Debian or Ubuntu environment for the Lab, you may want to use apt to do the installation of all the dependencies.

`#` **`sudo apt-get update`**

`#` **`sudo apt-get install wget patch dpkg-dev make debian-builder dh-make fakeroot diffutil`**

# Building RPM Packages
Estimated time: 15 minutes.
## The first package
First the best practice to work on packages is to work as a normal user, not as root. Building as root, if you have errors i nyour build configuration may lead to an unusable system, so it's important (and ture in geenral) to just adopt the minimum set of priviledges required for the operations we do. Of course, installing the package, once built, will require root priviledges, but everything else should be performed as a normal user.


`#` **`useradd rpm`**

In order to be able to manage a first package, the easiest approach is to import an existing one, before creating your own. For that we will refer to the public 

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
