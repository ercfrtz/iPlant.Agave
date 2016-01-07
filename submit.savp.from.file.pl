#!/usr/bin/perl

use warnings;
use strict;

my $filename = $ARGV[0];

open (GFILE, "<$filename");
while(my $input = <GFILE>)
{	
	chomp $input;
	my $systemArgs = "jobs-submit -F ".$input.".savp.job.json";
	#print $systemArgs."\n";
	system("$systemArgs");
	sleep(5); 
}

