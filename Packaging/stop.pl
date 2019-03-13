#!/usr/bin/perl -w

use strict;

my $nbctn = 10;
my $i = 1;

# Stop containers for Lab
while ($i <= $nbctn) {
	my $p = sprintf("%02d",$i);
	system "docker stop rpm$p";
	system "docker stop deb$p";
	$i++;
}
