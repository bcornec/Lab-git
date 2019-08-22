#!/usr/bin/perl -w

use strict;

my $nbctn = 20;
my $i = 1;

# Start dind

# Rebuild image
my $res = system "docker build -f Dockerfile.dockerlab -t dockerlab .";
exit(-1) if ($res != 0);

# Launch containers for Lab
while ($i <= $nbctn) {
	my $p = sprintf("%02d",$i);
	system "docker stop dockerlab$p";
	system "docker rm dockerlab$p";

	my $cmd = "docker run --privileged -d --name dockerlab$p -p 25$p:22 -p 80$p:80 dockerlab";
	print "Launching $cmd\n";
	$res = system "$cmd";
	exit(-1) if ($res != 0);
	$i++;
}
