# Python and Redfish Lab Contents
This lab purpose is to explore Redfish and become more familiar with the standard as well as how to interact with it using the python programming language

## Lab Writers and Trainers
  - Bruno.Cornec@hpe.com

Based on work from
  - Francois.Donze@hpe.com
  - Rene@flossita.org

<!--- [comment]: # Table of Content to be added --->

## Objectives of the Python Redfish Lab
At the end of the Lab students should be able to navigate through the various Refish fields, understand the differences between what is in the standard and the possible OEM additions, use existing python based tools to control servers equiped with such a standard and program themselves a client in python using existing libraries.

This Lab is intended to be trial and error so that during the session students should understand really what is behind the environment, instead of blindly following instructions, which never teach people anything IMHO. You've been warned ;-)

Expected duration : 120 minutes

## Prerequisite knowledge

Attendees must be familiar with the following technologies:
  - **HTTP** basics
  - **Linux commands** and utilities
  - The **vi** or **nano** editors
  - Basic scripting (in **Python** being a plus)

Of course, in case you're less familiar with these technologies, the Lab is still doable, just ask for help to your instructors in order to avoid being stuck on a related topic.

## Reference documents

This lab intends to be a **complement** (not a substitute) to the following public documents:
  - [Redfish DMTF Web site](http://redfish.dmtf.org/)
  - [HPE RESTFul API](https://developer.hpe.com/platform/ilo-restful-api/home)
  - [HPE RESTful API Reference doc](https://hewlettpackard.github.io/ilo-rest-api-docs/)
  - [Managing HPE Servers Using the HPE RESTful API](http://h20564.www2.hpe.com/hpsc/doc/public/display?docId=c04423967)
  - [HPE RESTful Interface Tool](http://www8.hp.com/us/en/products/server-software/product-detail.html?oid=7630408)
  - [HPE RESTful API overview video](https://www.youtube.com/watch?v=0OjD2lHNWUU)
  - [Redfish: the new standard for a Software Defined Infrastructure ](https://fosdem.org/2019/schedule/event/redfish_the_new_standard_for_a_software_defined_infrastructure/) with presentation and video.

When dealing with the Redfish standard, the first approach is to look at the reference Web site http://redfish.dmtf.org/ 

Estimated time for the lab is placed in front of each part.

# Environment setup
Estimated time: 5 minutes

This Lab supposes that your client machine will run a Windows OS. If you're lucky to have a Linux one, don't worry as the instructions also apply to it as well.

Before starting the lab exercises, your client station must be installed with the following:
  1. An SSH client ([PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) on Windows clients is OK)
  2. An HTTP client ([Firefox](http://mozilla.org) on all clients is OK)

For the rest of this Lab, each team has received a lab number (**XX**) from the instructor, and we'll refer to your server as **labXX**. It's IP will be provided by the instructor, and the port to use to connect to it with ssh is 22XX (example 2201 for Lab 01). You'll have to log on it using the **redfish** account with the password Redfish@TSS19

Test the access to your OS (a preinstalled CentOS 7 Linux distribution). 
Answer Yes to the confirmation query.
If the login is successful, exit from the system:

`$` **`exit`**

Lines started with a **`#`** are meant to be run as user root on your system, while lines starting with a **`$`** are meant to be run as the redfish user.

# REST and Redfish introduction
Estimated time: 5 minutes

## REST definition

Wikipedia says: “Representational State Transfer (REST) is a software architecture style consisting of guidelines [...] for creating scalable web services [...] REST [is] a simpler alternative to SOAP and WSDL-based web services.

RESTful systems typically, but not always communicate over the Hypertext Transfer Protocol with the same verbs (GET, POST, PUT, DELETE...) used by web browsers...”

## Redfish definition

Wikipedia says: “The Redfish standard is a suite of specifications that deliver an industry standard protocol providing Software Defined Management for Converged infrastructure.”

Different hardware manufacturers may implement parts or totality of the standard, and for additional information they want to manage, they have an Oem entrypoint in the schema allowing them to manage these. 

This hands on lab focuses on the standard Redfish implementation but may mention when extensions are needed or unavoidable. In order to minimize manufacturer aspetcs, we'll work mostly with simulators that implement the standard.

## Web browser and REST client

Although REST is primarily used via Application Programming Interfaces (APIs), it is possible to test and debug RESTful systems with a web browser and an associated extension. The extension is used to build the correct https packets (headers, payload...) and to display nicely (or not) returned answers in different formats (JSON, XML, raw...). 

If you need to use a browser different from Firefox or Chrome, make sure its associated extension supports the PATCH verb/method, in addition to GET and POST. The PATCH method is a proposed standard (RFC 5789) and is required by the redfish specifications.

Now that your setup and some introduction has been done, let's start experimenting with Redfish.

# Discovering Redfish
Estimated time: 15 minutes.

## Using the DMTF mockups

The goal of this exercise is to understand the schemas provided by the standard and the various information one can retrieve from a Redfish managed system.

If you go to the Redfish DMTF mockups provided online at https://redfish.dmtf.org/redfish/v1, you'll be able to nativate using Redfish on different type of systems. Try first the [Simple Rack-mounted Server](https://redfish.dmtf.org/redfish/mockups/v1/863) and explore the 3 main entry points that will be relevant for this lab: [Systems](https://redfish.dmtf.org/redfish/mockups/v1/863#Systems), [Chassis](https://redfish.dmtf.org/redfish/mockups/v1/863#Chassis) and [Managers](https://redfish.dmtf.org/redfish/mockups/v1/863#Managers).

In this case (a traditional rack or blade server), the Total number of “Systems” contained in the Members array is 1. Compare this with what you get when parsing the [Systems](https://redfish.dmtf.org/redfish/mockups/v1/862#Systems) entrypoint of a Blade Chassis.

On a real system, to view the properties related to item 1 of this System, you would need to use the following URL: **https://IP/redfish/v1/Systems/1**

The exhaustive list of properties is returned, including various BIOS configuration items (BIOS version, SKU, Part/Asset/Serial #, Status, Boot order, inventory for CPU, RAM, ...), an Oem section to provide additional non-standardized information, links to other related components (Chassis, Manager), possible actions like the different Reset possibilities (ResetType)

In addition to the Systems link, the data model proposes others entry points like Chassis and Managers.

A partial view of the data model is:

![Redfish Data Model](img/redfish-classes.png)

Navigate now through the [Chassis](https://redfish.dmtf.org/redfish/mockups/v1/863#Chassis) link. You should notice that the it contains physical properties of the server(s).

Perform a similar navigation in the [Managers](https://redfish.dmtf.org/redfish/mockups/v1/863#Managers) location. What is the type of content under Managers? Confirm your findings with the data model picture just above. Find the MAC address of the BMC.

Change mockup to look at differences when dealing with a [Bladed system](https://redfish.dmtf.org/redfish/mockups/v1/862), made of a chassis with multiple computers (look at how having an enclosure impacts the representation, find the MAC address of the enclosure management card)  or with a [Composable System](https://redfish.dmtf.org/redfish/mockups/v1/868) made of blocks of CPUs, memory and disks (look at the new Composition service in particular)

## Using the HPE iLO RESTful API Explorer

Now that you have a better understanding of the Redfish Data Model, let's see what it gives on real hardware. Point your browser to the [HPE iLO RESTful API Explorer](https://ilorestfulapiexplorer.ext.hpe.com/). Explore again and remark differences. As an example, look for the BIOS entry for the system and compare the list between the mockup of the [Simple Rack-mounted Server](https://redfish.dmtf.org/redfish/mockups/v1/863) and the real system.

## Using Command Line Interface tools

Using a Web browser to get and set properties in a server is very useful for learning or troubleshooting. However, browsing the data model becomes quickly complex. For a quick acces to information, you may want to use Command Line Interface based tools. Multiple possibilities exist here, either using generic tools to interact with the RESTful API, or more specific, very often written in python, aware of the Redfish data model.

### Using wget or curl

`wget` and `curl` are non-interactive CLI network downloaders available on Linux. They can be used to send https requests and perform actions via the Redfish API. They are already available on your system.

On your server, as root (you are authorized to use sudo), install `jq` (hosted on the EPEL repository) to help visualize the JSON answers from the manager: 

`#` **`yum install -y epel-release`**

`#` **`yum install -y jq`**

Use these tools to walk through the Redfish data model on the public HPE simulator:

`$` **`curl -k https://ilorestfulapiexplorer.ext.hpe.com/redfish/v1 | jq`**

You now have a visibility of the main entrypoints for the system studied.

Find the values of the CPU0 power consumption, by exploring the MetricReports of the TelemetryService.
You should find a value around 34.

As upper, find also the MAC address of the first BMC interface looking under the Managers entrypoint.

With these tools you can also modify vales or launch actions on the remote system. 

`$` **`curl --dump-header - -k --request PATCH -H "OData-Version: 4.0 " -H "Accept: application/json " -H "Content-Type: application/json " --data '{"Action": "Reset"}' https://ilorestfulapiexplorer.ext.hpe.com/redfish/v1/Managers/1/EthernetInterfaces/1/`**

On a real server, this would work and reset the BMC. On the simulator, it raises an error instead.
But of course, as you can see, it becomes more and more complex to use a CLI interface to dialog with the BMC using Redfish.

Using a programming language such as C, JavaScript, Ruby makes such dialog simpler. We'll use Python in the rest of the lab to perform this interaction. See bindings for all these languages provided by HPE at https://www.hpe.com/us/en/servers/restful-api.html#Portfolio

<!--- 
`Host#` **`curl --dump-header - --insecure -u demopaq:password --request PATCH -H "OData-Version: 4.0 " -H "Accept: application/json " -H "Content-Type: application/json " --data '{"Oem": { "Hp": { "HostName": "ilo-foobar" } } }' https://10.3.222.10X/redfish/v1/Managers/1/EthernetInterfaces/1/`**
--->

# A short Python introduction
Estimated time: 20 minutes.

We won't pretend to train you on such a rich language as python. We hope to give you enough tips so you can progress in this lab as much as possible understanding how to use Redfish programmatically.

The python language and its multiple web and security related modules provides a perfect eco-system for creating RESTful for iLO programs. 

Python is an interpreted language, object oriented, portable, easy to learn as other scripting languages, while preserving the power of advanced languages such as C or Java, in particular thanks to its large libray of modules.

There are 2 versions of the language. Version 2 is already installed by default in your CentOS 7 environement. Version 3 can also be installed in parallel to benefit from the latest features, and work on the up to date version. 

Python can also be used interactively to test commands by just launching the `python` command.

`$` **`python`**
```
Python 2.7.5 (default, Oct 30 2018, 23:45:53) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-36)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
```
`>>>` **`i=2+3`**
`>>>` **`print(i)`**
```
5
```
`>>>` **`txt='coucou'`**
`>>>` **`print(txt)`**
```
coucou
>>> 
```

Indentation is link to syntax and mandatory in python. Each block should be indented with a similar manner. Comments are preceded with a `#` like in may other scripting languages (shell, perl, ...). There are multiple data types such as integer (int), floating point numbers (float), strings of characters (string) and booleans among the one we will used. Another useful type is the dictionary (a key value data structure, like a perl hash)

Type ^D to exit the interpretor.

Much more is needed to understand the python language bases (a 3 day training is generally required), but we'll start with this.

## Using the request python module

We will first connect to the Redfish simulator making an HTTP connection similar to what we have done previously with curl, but this time with python using the request module. First install the module which is not part of the standard library:

`#` **`yum install -y python-requests`**

Then create the following script `using-requests.py` using an editor such as `vi` (if you're familiar with it) or `nano` (that you'd need to install) to arrive to the following result:

`$` **`cat using-requests.py`**
```
import requests

req = requests.get("https://ilorestfulapiexplorer.ext.hpe.com/redfish/v1/Managers/1/EthernetInterfaces/1/", verify=False)
print(req.content)
```

The documentation of the requests module is available at http://docs.python-requests.org/en/master/. The first line tells to python to use that module (like a C library). It allows to make an HTTP requests (using the GET verb of the RESTful API) to our Redfish entrypoint, not verifying the certificate as we know it's not imported locally (similar to the -k option of curl ealier).
The req variable will collect the result of that request and is an object with attricbutes, one being `content` which contains the content of the reply. Note that it also has a `ok` attribute, bolean indicating that the query was handled correctly and that should be used if we would analyze errors correctly (which is not our case here).

Now invoke that script to see the result:

`$` **`python using-requests.py`**
```
/usr/lib/python2.7/site-packages/urllib3/connectionpool.py:769: InsecureRequestWarning: Unverified HTTPS request is being made. Adding certificate verification is strongly advised. See: https://urllib3.readthedocs.org/en/latest/security.html
  InsecureRequestWarning)
{"@odata.context": "/redfish/v1/$metadata#EthernetInterface.EthernetInterface", "@odata.etag": "W/\"DD66F09A\"", "@odata.id": "/redfish/v1/Managers/1/EthernetInterfaces/1/", "@odata.type": "#EthernetInterface.v1_4_1.EthernetInterface", "AutoNeg": true, "Description": "Configuration of this Manager Network Interface", "DHCPv4": {"DHCPEnabled": true, "UseDNSServers": true, "UseDomainName": true, "UseGateway": true, "UseNTPServers": false, "UseStaticRoutes": true}, "DHCPv6": {"OperatingMode": "Stateful", "UseDNSServers": true, "UseDomainName": true, "UseNTPServers": false, "UseRapidCommit": false}, "FQDN": "DL380Gen10.example.net", "FullDuplex": true, "HostName": "DL380Gen10", "Id": "1", "InterfaceEnabled": true, "IPv4Addresses": [{"Address": "30.204.61.23", "AddressOrigin": "DHCP", "Gateway": "30.204.60.1", "SubnetMask": "255.255.252.0"}], "IPv4StaticAddresses": [], "IPv6Addresses": [{"Address": "FE80::9AF2:B3FF:FEEE:FAFA", "AddressOrigin": "SLAAC", "AddressState": "Preferred", "PrefixLength": 64}], "IPv6AddressPolicyTable": [{"Label": null, "Precedence": 35, "Prefix": "::ffff:0:0/96"}], "IPv6DefaultGateway": "::", "IPv6StaticAddresses": [{"Address": "::", "PrefixLength": null}, {"Address": "::", "PrefixLength": null}, {"Address": "::", "PrefixLength": null}, {"Address": "::", "PrefixLength": null}], "IPv6StaticDefaultGateways": [{"Address": "::"}], "MACAddress": "98:F2:B3:EE:FA:FA", "MaxIPv6StaticAddresses": 4, "Name": "Manager Dedicated Network Interface", "NameServers": ["32.4.135.52", "32.4.135.51"], "Oem": {"Hpe": {"@odata.context": "/redfish/v1/$metadata#HpeiLOEthernetNetworkInterface.HpeiLOEthernetNetworkInterface", "@odata.type": "#HpeiLOEthernetNetworkInterface.v2_2_1.HpeiLOEthernetNetworkInterface", "ConfigurationSettings": "Current", "DHCPv4": {"ClientIdType": "Default", "Enabled": true, "UseDNSServers": true, "UseDomainName": true, "UseGateway": true, "UseNTPServers": false, "UseStaticRoutes": true, "UseWINSServers": true}, "DHCPv6": {"StatefulModeEnabled": true, "StatelessModeEnabled": true, "UseDNSServers": true, "UseDomainName": true, "UseNTPServers": false, "UseRapidCommit": false}, "DomainName": "example.net", "HostName": "DL380Gen10", "InterfaceType": "Dedicated", "IPv4": {"DDNSRegistration": true, "DNSServers": ["32.4.135.52", "32.4.135.51", "0.0.0.0"], "StaticRoutes": [{"Destination": "0.0.0.0", "Gateway": "0.0.0.0", "SubnetMask": "0.0.0.0"}, {"Destination": "0.0.0.0", "Gateway": "0.0.0.0", "SubnetMask": "0.0.0.0"}, {"Destination": "0.0.0.0", "Gateway": "0.0.0.0", "SubnetMask": "0.0.0.0"}], "WINSRegistration": true, "WINSServers": ["0.0.0.0", "0.0.0.0"]}, "IPv6": {"DDNSRegistration": true, "DNSServers": ["::", "::", "::"], "SLAACEnabled": true, "StaticDefaultGateway": "::", "StaticRoutes": [{"Destination": "::", "Gateway": "::", "PrefixLength": null, "Status": "Unknown"}, {"Destination": "::", "Gateway": "::", "PrefixLength": null, "Status": "Unknown"}, {"Destination": "::", "Gateway": "::", "PrefixLength": null, "Status": "Unknown"}]}, "NICEnabled": true, "NICSupportsIPv6": true, "PingGatewayOnStartup": true}}, "PermanentMACAddress": "98:F2:B3:EE:FA:FA", "SpeedMbps": 1000, "StatelessAddressAutoConfig": {"IPv6AutoConfigEnabled": true}, "StaticNameServers": ["0.0.0.0", "0.0.0.0", "0.0.0.0", "::", "::", "::"], "Status": {"Health": "OK", "State": "Enabled"}}
```

You can use the `jq` command to have a more visible output, such as what was done previously.

Ok, so all that for the same result as before ? Well that's just a start as now that we have in a variable the content of the JSON output, then we can use an additional python module to anaylse more in depth.

## Using the JSON module

Copy the previous script `using-requests.py` into `using-json.py` and amend it so that it looks like the following:

`$` **`cat using-json.py`**
```
import requests
import json

req = requests.get("https://ilorestfulapiexplorer.ext.hpe.com/redfish/v1/Managers/1/EthernetInterfaces/1/", verify=False)
#print(req.content)
data = json.loads(req.content)
print(data)
```

The json module is standard in python and its doc is availabel at https://docs.python.org/2/library/json.html
So we now use the json module in addition and its loads method on the content we got from the previous HHTP RESTful GET request to put it in a new `data` variable. And we print that variable.

Now invoke that script to see the result:

`$` **`python using-json.py`**
```
/usr/lib/python2.7/site-packages/urllib3/connectionpool.py:769: InsecureRequestWarning: Unverified HTTPS request is being made. Adding certificate verification is strongly advised. See: https://urllib3.readthedocs.org/en/latest/security.html
  InsecureRequestWarning)
{u'StatelessAddressAutoConfig': {u'IPv6AutoConfigEnabled': True}, u'IPv6DefaultGateway': u'::', u'PermanentMACAddress': u'98:F2:B3:EE:FA:FA', u'IPv6Addresses': [{u'AddressState': u'Preferred', u'AddressOrigin': u'SLAAC', u'PrefixLength': 64, u'Address': u'FE80::9AF2:B3FF:FEEE:FAFA'}], u'@odata.type': u'#EthernetInterface.v1_4_1.EthernetInterface', u'Description': u'Configuration of this Manager Network Interface', u'HostName': u'DL380Gen10', u'FQDN': u'DL380Gen10.example.net', u'@odata.context': u'/redfish/v1/$metadata#EthernetInterface.EthernetInterface', u'DHCPv4': {u'UseStaticRoutes': True, u'UseGateway': True, u'UseDNSServers': True, u'UseDomainName': True, u'UseNTPServers': False, u'DHCPEnabled': True}, u'DHCPv6': {u'UseDomainName': True, u'UseRapidCommit': False, u'OperatingMode': u'Stateful', u'UseNTPServers': False, u'UseDNSServers': True}, u'Oem': {u'Hpe': {u'@odata.type': u'#HpeiLOEthernetNetworkInterface.v2_2_1.HpeiLOEthernetNetworkInterface', u'NICEnabled': True, u'DomainName': u'example.net', u'HostName': u'DL380Gen10', u'@odata.context': u'/redfish/v1/$metadata#HpeiLOEthernetNetworkInterface.HpeiLOEthernetNetworkInterface', u'DHCPv4': {u'UseWINSServers': True, u'UseStaticRoutes': True, u'UseGateway': True, u'Enabled': True, u'UseDNSServers': True, u'UseDomainName': True, u'UseNTPServers': False, u'ClientIdType': u'Default'}, u'DHCPv6': {u'StatefulModeEnabled': True, u'UseDNSServers': True, u'UseDomainName': True, u'StatelessModeEnabled': True, u'UseNTPServers': False, u'UseRapidCommit': False}, u'InterfaceType': u'Dedicated', u'IPv4': {u'StaticRoutes': [{u'SubnetMask': u'0.0.0.0', u'Destination': u'0.0.0.0', u'Gateway': u'0.0.0.0'}, {u'SubnetMask': u'0.0.0.0', u'Destination': u'0.0.0.0', u'Gateway': u'0.0.0.0'}, {u'SubnetMask': u'0.0.0.0', u'Destination': u'0.0.0.0', u'Gateway': u'0.0.0.0'}], u'DDNSRegistration': True, u'WINSServers': [u'0.0.0.0', u'0.0.0.0'], u'DNSServers': [u'32.4.135.52', u'32.4.135.51', u'0.0.0.0'], u'WINSRegistration': True}, u'IPv6': {u'StaticRoutes': [{u'Status': u'Unknown', u'Destination': u'::', u'PrefixLength': None, u'Gateway': u'::'}, {u'Status': u'Unknown', u'Destination': u'::', u'PrefixLength': None, u'Gateway': u'::'}, {u'Status': u'Unknown', u'Destination': u'::', u'PrefixLength': None, u'Gateway': u'::'}], u'DDNSRegistration': True, u'DNSServers': [u'::', u'::', u'::'], u'StaticDefaultGateway': u'::', u'SLAACEnabled': True}, u'ConfigurationSettings': u'Current', u'PingGatewayOnStartup': True, u'NICSupportsIPv6': True}}, u'IPv6AddressPolicyTable': [{u'Prefix': u'::ffff:0:0/96', u'Precedence': 35, u'Label': None}], u'Status': {u'State': u'Enabled', u'Health': u'OK'}, u'Name': u'Manager Dedicated Network Interface', u'@odata.id': u'/redfish/v1/Managers/1/EthernetInterfaces/1/', u'StaticNameServers': [u'0.0.0.0', u'0.0.0.0', u'0.0.0.0', u'::', u'::', u'::'], u'IPv4Addresses': [{u'SubnetMask': u'255.255.252.0', u'AddressOrigin': u'DHCP', u'Gateway': u'30.204.60.1', u'Address': u'30.204.61.23'}], u'IPv4StaticAddresses': [], u'AutoNeg': True, u'MaxIPv6StaticAddresses': 4, u'MACAddress': u'98:F2:B3:EE:FA:FA', u'FullDuplex': True, u'IPv6StaticAddresses': [{u'PrefixLength': None, u'Address': u'::'}, {u'PrefixLength': None, u'Address': u'::'}, {u'PrefixLength': None, u'Address': u'::'}, {u'PrefixLength': None, u'Address': u'::'}], u'NameServers': [u'32.4.135.52', u'32.4.135.51'], u'InterfaceEnabled': True, u'SpeedMbps': 1000, u'IPv6StaticDefaultGateways': [{u'Address': u'::'}], u'Id': u'1', u'@odata.etag': u'W/"DD66F09A"'}
```

So it seems to be the same and that we have not made progresses, but that's not really the case ;-)
The difference is that we now have the content in a dictionary (the data variable) that is easily usable in python. Let's amend again our program to just display the MAC address of our manager. Copy first the previous script `using-json.py` into `display-mac.py` and amend it so that it looks like the following:

`$` **`cat display-mac.py`**
```
import json

req = requests.get("https://ilorestfulapiexplorer.ext.hpe.com/redfish/v1/Managers/1/EthernetInterfaces/1/", verify=False)
#print(req.content)
data = json.loads(req.content)
#print(data)
print(data['MACAddress'])
```

So a dictionary is a key/value way of storing data. In the previous executinon, we have seen that each Redfish entrypoint was a key of the dictionary, so printing the `data['MACAddress']` is giving the value of the dictionary's entry indexed by the MACAddress key.

Now invoke that script to see the result:

`$` **`python display-mac.py`**
```
/usr/lib/python2.7/site-packages/urllib3/connectionpool.py:769: InsecureRequestWarning: Unverified HTTPS request is being made. Adding certificate verification is strongly advised. See: https://urllib3.readthedocs.org/en/latest/security.html
  InsecureRequestWarning)
98:F2:B3:EE:FA:FA
```

So you have made a 5 lines python script which returns the MACAddress of your manager using the Redfish protocol ! Great job. Of course, no check is done on function calls, so that's far from being prodcution ready, but you get the idea now. If you want to improve that you can look at the try keyword in the python language at https://docs.python.org/2/tutorial/errors.html#handling-exceptions

Redo these steps to find the BIOS Version of the simulator.

Of course, as you can see, this is on one hand very useful to get information out of the Redfish intercace, but also tedious and very manual if you have many parameters to manage.

## Using the python-redfish library
Estimated time: 15 minutes

The python-redfish library is a reference implementation to enable Python developers to communicate with the [Redfish API](http://www.dmtf.org/standards/redfish).
The project is still in it's infancy but already allows to retrieve information and perform few actions.
The goal of this project compared to the HPE or DMTF SDK is to stick to the Redfish standard to allow compatibility between HW providers. So not to manage the Oem "proprietary/private" part provided by HW company such as HPE (or only for exceptions).

The project also comes with a client in order to interact with Redfish and is mainly used to validate the library.

This is a full 100% Free and Open Source Software, under the Apache v2 license and contributions are welcome at https://git.openstack.org/cgit/openstack/python-redfish ! :)

### Install the required repository

Install the python-redfish repository.

`#` **`cd /etc/yum.repos.d`**

`#` **`cat > python-redfish.repo << EOF`**
```
[python-redfish]
name=centos 7 x86_64 - python-redfish Vanilla Packages
baseurl=ftp://ftp.mondorescue.org/centos/7/x86_64
enabled=1
gpgcheck=0
gpgkey=ftp://mondo.hpintelco.org/centos/7/x86_64/python-redfish.pubkey
EOF
```

Now, install `python-redfish`.

`#` **`yum install -y --setopt=tsflags='' python-pbr python-setuptools python-redfish`**

The setopt option passed here disables the non-installation of man page and docs, which will be useful later on (default configuration of the CentOS 7 Docker miage)

### Using the redfish-client

Launch the binary, it should provide the usage:

`$` **`redfish-client`**
```
Usage:
   redfish-client [options] config add <manager_name> <manager_url> [<login>] [<password>]
   redfish-client [options] config del <manager_name>
   redfish-client [options] config modify <manager_name> (manager_name | url | login | password) <changed_value>
   redfish-client [options] config show
   redfish-client [options] config showall
   redfish-client [options] manager getinfo [<manager_name>]
   redfish-client [options] chassis getinfo [<manager_name>]
   redfish-client [options] system getinfo [<manager_name>]
   redfish-client (-h | --help)
   redfish-client --version
```
Use the client to register a redfish manager.
Manager is the wording used to define a management interface such as an iLO for instance.

`$` **`redfish-client config add ilosim https://ilorestfulapiexplorer.ext.hpe.com/redfish/v1`**

`$` **`redfish-client config showall`**
```
Managers configured :
ilosim
        Url : https://ilorestfulapiexplorer.ext.hpe.com/redfish/v1
        Login :
        Password :
```

Then retrieve manager data:

`$` **`redfish-client manager getinfo ilosim`**
```
Gathering data from manager, please wait...

Connection error : [Errno 1] _ssl.c:504: error:14090086:SSL routines:SSL3_GET_SERVER_CERTIFICATE:certificate verify failed
1- Check if the url is the correct one
2- Check if your device is answering on the network
3- Check if your device has a valid trusted certificat
   You can use openssl to validate it using the command :
   openssl s_client -showcerts -connect <server>:443
4- Use option "--insecure" to connect without checking   certificate
```
It fails, because there is no certificate installed on the iLO simulator.

`$` **`redfish-client manager getinfo ilosim --insecure`**
```
Gathering data from manager, please wait...

Redfish API version :  1.60
HPE RESTful Root Service

Managers information :
======================

Manager id 1:
UUID : b99e4bae-dd75-588c-b9d1-bc6cff4296a9
Type : BMC
Firmware version : iLO 5 v1.40
Status : State :  / Health : 
Ethernet Interface :
    Ethernet Interface id 1 :
    Manager Dedicated Network Interface
    FQDN : DL380Gen10.example.net
    Mac address : 98:F2:B3:EE:FA:FA
    Address ipv4 : 30.204.61.23
    Address ipv6 : FE80::9AF2:B3FF:FEEE:FAFA
    Ethernet Interface id 2 :
    Manager Shared Network Interface
    FQDN : DL380Gen10.
    Mac address : 98:F2:B3:EE:FA:FB
    Address ipv4 : 0.0.0.0
    Address ipv6 : 
    Ethernet Interface id 3 :
    Manager Virtual Network Interface
    FQDN : Not available
    Mac address : 00:CA:FE:F0:0D:04
    Address ipv4 : 32.4.15.1
    Address ipv6 : 
Managed Chassis :
        1
Managed System :
        1
----------------------------
```

You can check that the MAC address for the manager is consistent with what you got earlier.

Now retrieve system data:

`$` **`redfish-client system getinfo ilosim --insecure`**
```
Gathering data from manager, please wait...

Redfish API version :  1.60
HPE RESTful Root Service

Systems information :
=====================

System id 1:
UUID : 35363238-3536-4D32-3237-343930335857
Type : Physical
Manufacturer : HPE
Model : ProLiant DL380 Gen10
SKU : 826565-B21
Serial : 2M274903XW
Hostname : localhost.example.net
Bios version : U30 v2.10 (01/18/2019)
CPU number : 1
CPU model : Intel(R) Xeon(R) Silver 4114 CPU @ 2.20GHz
CPU details :
    Processor id 1 :
    Speed : 4000
    Cores : 10
    Threads : 20
    
    Processor id 2 :
    Speed : 4000
    Cores : 0
    Threads : 0
    
Available memory : 32 GB
Status : State : OK / Health : OK
Power : On
Description : Not available
Chassis : 1
Managers : 1
IndicatorLED : Off

Ethernet Interface :
    Ethernet Interface id 1 :
    
    FQDN : Not available
    Mac address : 98:f2:b3:ee:fa:fc
    Address ipv4 : 
    Address ipv6 : 
    Ethernet Interface id 2 :
    
    FQDN : Not available
    Mac address : 98:f2:b3:ee:fa:fd
    Address ipv4 : 
    Address ipv6 : 
    Ethernet Interface id 3 :
    
    FQDN : Not available
    Mac address : 98:f2:b3:ee:fa:fe
    Address ipv4 : 
    Address ipv6 : 
    Ethernet Interface id 4 :
    
    FQDN : Not available
    Mac address : 98:f2:b3:ee:fa:ff
    Address ipv4 : 
    Address ipv6 : 
Looking for potential OEM information :
    This system has no supplemental OEM information


Simple Storage :
    This system has no simple storage as Redfish standard data
Looking for potential OEM information :
    This system has no supplemental OEM information
--------------------------------------------------------------------------------
```
Enable debugging information:

`$` **`redfish-client system getinfo ilosim --insecure --debug=3`**
```
[...]
Lots of debugging info !
[...]
```

This allows to see all the calls made, as the client is parsing the full Redfish tree to store data in a dictionary (done at the library level), before extracting what is supposed useful for your system. That also explains why the command take some time before answering.

### Using the python-redfish library directly

The library comes with a simple example called '`simple-proliant.py`' to use the library itself.

`#` **`cd /usr/share/doc/python-redfish-0.4.1`**

`#` **`more simple-proliant.py`**

This code is a bit more 
For the moment, please comment all the lines containing '`set_parameters`'. Then you can run:

`#` **`python simple-proliant.py`**

Now you can look at the python code to get data and perform some actions. The library documentation is available at: http://pythonhosted.org/python-redfish. The classes are defined here: http://pythonhosted.org/python-redfish/python-redfish_lib.html.

You can then comment/uncomment and modify the code to experiment. e.g. below:

Retrieve manager bios version:
```
print(remote_mgmt.Systems.systems_dict["1"].get_bios_version())
```
Retrieve chassis manufacturer:
```
print(remote_mgmt.Chassis.chassis_dict["1"].get_manufacturer())
```
Print chassis type:
```
print(remote_mgmt.Chassis.chassis_dict["1"].get_type())
```

Uncommenting the following line should reboot the system on a real machine:
```
# mySystem.reset_system()
```


## Using an existing python DMTF example

The DMTF provides a set of python tools and modules to help manage your Redfish environment at https://github.com/DMTF

Among them, we will have a closer look at the python-redfish-library available at https://github.com/DMTF/python-redfish-library

In order to install it we will need pip (which is the python installer program which install directly from the PyPI reference site (https://pypi.org/) the modules you want to add to your python distribution and which have not been packaged (yet !) by your Linux distribution).

So first start by installing pip:

`#` **`yum install -y python-pip`**

Then you can follow the installation instructions for the library with the pip command. If you get a permission denied message, it may be because you're not running the command as root, so you have no rights to install the software in the python directory structure. A way to mitigate that is to use the virtualenv feature of python, which creates a local python environement, that you can pollute without impacting the main installation. So do not become root to force the installation, but instead run:

`#` **`yum install -y python-virtualenv`**

You now have a new commd, `virtualenv` that you'll be able to use to create that particular local python environement:

`$` **`virtualenv redfish`**

Then put yourself in the virtualenv configuration:

`$` **`source redfish/bin/activate`**

Your prompt should change to reflect that modification. You now have a completely separate python environment you can play with, without impacting the one running on the system. This is pretty handy and can also allow to manage multiple python versions in parallel. So now, let's install safely the redfish module here:

`$` **`pip install redfish`**

That should work. And as you can remark, another advantage is that you don't need to be root to do it. You can test it by importing the redfish module with the local python interpreter (See https://github.com/DMTF/python-redfish-library#import-the-relevant-python-module if you're lost !).

This module provides a Redfish object with 3 attributes (URL, account, password).

The following python script is for didactic purposes only, and HPE does not support it. Use it with care. It requires python 2.7 or later. Sending low-level configuration commands can be dangerous to running systems and to avoid any problem, the user must understand what he does... NOTE: This version is not fully Redfish 1.0 compliant. A future version will be.

This python script contains several examples. We will explain how to run the first one and, if you have time, you will be able to run others. 

A version of this script is present in your environment, but later you can download the latest version of this file from: https://github.com/HewlettPackard/python-ilorest-library

Before launching the script, and for security reasons, you need to edit it with your favorite editor and perform at least three tasks. 

`Host#` **`vi HpRestfulApiExamplesExperimental.py –c 1889`**

Supply your iLO info around line 1889:
  1. `host = ’10.3.222.10X’`
  1. `iLO_loginname = ‘demopaq’`
  1. `iLO_password = ‘password’`

Comment out the `sys.exit` call around line 1902:
```
# sys.exit (-1)
```
Move the `if False:` directive below exercice1 and remove leading spaces of exercise1:
```
ex1_change_bios_setting(host, 'AdminName', 'Mr. Rest',... )
if False:
    ex2_reset_server(host, iLO_loginname, iLO_password)
    ex3_enable_secure_boot(host, False, iLO_loginname, iLO_password)
[...]
```
Save the file and exit.
Execute the script. It will modify the `AdminName` UEFI Bios parameter:

`Host#` **`python HpRestfulApiExamplesExperimental.py`**

![Python script execution](img/python-run.png)

Using the REST client Browser, verify that your modification is not yet in the BIOS, but still in the pending area of the BIOS. In BIOS, you should still read `"AdminName": "Foo Bar"`:

![Python script result1](img/python-result.png)

In the pending area, you should see your modification:

![Python script result2](img/python-result2.png)

NOTE: The pending area of the BIOS will updated with your modification at next reboot.
Feel free to try other exercises and investigate how they have been implemented in this python script.

At the end exit from the virtualenv configuration:

`$` **`deactivate`**

## Conclusion

The iLO RESTful API provides a rich set of means to display and modify HPE ProLiant servers. And as usual there is more than one way to do it, even in python ;-)
