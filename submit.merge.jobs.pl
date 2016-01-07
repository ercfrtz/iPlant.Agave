#!/usr/bin/perl

use warnings;
use strict;

my $dirname = $ARGV[0];
my $submitNumber = $ARGV[1];
my $counter = 0;

opendir(DIR, $dirname) || die "Error opening dir $dirname\n";

while((my $filename = readdir(DIR)))
{	
	if($filename =~ /.merge.job.json/ && $counter < $submitNumber)
	{
		my $systemArgs = "jobs-submit -F ".$filename." >> active.jobs.list";
		#print $systemArgs."\n";
		system("$systemArgs");
		$systemArgs = "rm ".$filename;
		#print $systemArgs."\n";
		system("$systemArgs");
		$counter++;
		sleep(5); 
	}
}
