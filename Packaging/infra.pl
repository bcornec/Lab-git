#!/usr/bin/perl -w

use strict;

my $nbctn = 10;
my $i = 1;

# Rebuild image
my $res = system "docker build -f Dockerfile.rpm -t pkg .";
exit(-1) if ($res != 0);

# Launch containers for Lab
while ($i <= $nbctn) {
	my $p = sprintf("%02d",$i);
	system "docker stop pkg$p";
	system "docker rm pkg$p";
	my $cmd = "docker run -d --name pkg$p -p 22$p:22 pkg";
	print "Launching $cmd\n";
	$res = system "$cmd";
	exit(-1) if ($res != 0);
	$i++;
}
