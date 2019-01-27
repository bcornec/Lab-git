#!/usr/bin/perl -w

use strict;

my $nbctn = 10;
my $i = 1;

# Rebuild image
my $res = system "docker build -f Dockerfile.rpm -t rpm .";
exit(-1) if ($res != 0);
$res = system "docker build -f Dockerfile.deb -t deb .";
exit(-1) if ($res != 0);

# Launch containers for Lab
while ($i <= $nbctn) {
	my $p = sprintf("%02d",$i);
	system "docker stop rpm$p";
	system "docker rm rpm$p";
	my $cmd = "docker run -d --name rpm$p -p 22$p:22 rpm";
	print "Launching $cmd\n";
	$res = system "$cmd";
	exit(-1) if ($res != 0);
	system "docker stop deb$p";
	system "docker rm deb$p";
	$cmd = "docker run -d --name deb$p -p 23$p:22 deb";
	print "Launching $cmd\n";
	$res = system "$cmd";
	exit(-1) if ($res != 0);
	$i++;
}
