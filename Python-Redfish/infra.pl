#!/usr/bin/perl -w

use strict;

my $nbctn = 1;
my $i = 1;

# Rebuild image
my $res = system "docker build -f Dockerfile.redfish.opensuse -t redfish .";
exit(-1) if ($res != 0);

# Launch containers for Lab
while ($i <= $nbctn) {
	my $p = sprintf("%02d",$i);
	system "docker stop redfish$p";
	system "docker rm redfish$p";
	my $cmd = "docker run -d --name redfish$p -p 22$p:22 redfish";
	print "Launching $cmd\n";
	$res = system "$cmd";
	exit(-1) if ($res != 0);
	$i++;
}
