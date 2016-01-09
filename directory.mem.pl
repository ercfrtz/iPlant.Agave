#!/usr/bin/perl

use warnings;
use strict;

my $dirname = "/ipant/home/path/to/data/";
my $systemArgs = "";
my $prevBreed = "";
my $prevID = "";
my $listOfFiles = "";

$systemArgs = "~/irods2.5.icmds.mac.intel/ils ".$dirname." > file.listing";
system("$systemArgs");

open (FILELISTING, "<file.listing");
while(my $finput = <FILELISTING>)
{
  	chomp $finput;
  	if($finput =~ /1_Unique.fastq.gz/ && !($finput =~ /md5/))
  	{
  		$finput =~ s/\s//g;
  		my $secondFile = $finput;
  		$secondFile =~ s/.1_/.2_/;
  		my @baseSplit = split(/_/, $finput);
  		my @nameBase = split(/\./, $baseSplit[0]);
  		my $fileBaseName = $nameBase[0].".".$nameBase[1].".".$nameBase[2].".".$nameBase[3];
  		my $jsonFile = $fileBaseName.".mem.job.json";
  		open my $EJFILE, ">", $jsonFile or die("Could not open file. $!");
  		print $EJFILE "{\n";
    	print $EJFILE '"jobName": "savp-bwa-mem-030-01",'."\n";
    	print $EJFILE '"softwareName": "ianimal-savp-bwa-mem-0.3.0u1",'."\n";
    	print $EJFILE '"processorsPerNode": 12,'."\n";
    	print $EJFILE '"requestedTime": "24:00:00",'."\n";
    	print $EJFILE '"memoryPerNode": 24,'."\n";
    	print $EJFILE '"nodeCount": 1,'."\n";
    	print $EJFILE '"batchQueue": "normal",'."\n";
    	print $EJFILE '"archive": true,'."\n";
    	print $EJFILE '"archivePath": "ercfrtz/schnabel/",'."\n";
    	print $EJFILE '"inputs": {'."\n";
        print $EJFILE '"inputSequence1": "agave://data.iplantcollaborative.org/path/to/data/'.$finput.'",'."\n";
        print $EJFILE '"inputSequence2": "agave://data.iplantcollaborative.org/path/to/data/'.$secondFile.'",'."\n";
        print $EJFILE '"referenceBundle": "agave://data.iplantcollaborative.org/shared/iastate-tacc-genomics/umd_3_1_Y_Mito.tar"'."\n";
    	print $EJFILE '},'."\n";
    	print $EJFILE '"parameters": {'."\n";
        print $EJFILE '"inputBarcode": "'.$fileBaseName.'",'."\n";
        print $EJFILE '"cleanupParameter": true'."\n";
    	print $EJFILE '},'."\n";
    	print $EJFILE '"outputs": {'."\n";
    	print $EJFILE '}'."\n";
		print $EJFILE '}'."\n";
		close $EJFILE;
		
		if($prevBreed eq "" && $prevID eq "")
		{
			$prevBreed = $nameBase[0];
			$prevID = $nameBase[1];
			$listOfFiles = '"agave://data.iplantcollaborative.org/path/to/output/'.$fileBaseName.'.mem.bam"';
		}
		elsif($nameBase[0] eq $prevBreed && $nameBase[1] eq $prevID)
		{
			$listOfFiles .= ',"agave://data.iplantcollaborative.org/path/to/output/'.$fileBaseName.'.mem.bam"';
		}
		else
		{
			my $mergeFile = $prevBreed.".".$prevID.".merge.job.json";
			open my $MFILE, ">", $mergeFile or die("Could not open file. $!");
			print $MFILE "{\n";
  			print $MFILE '"name":"test-savp-merge-sams-01",'."\n";
  			print $MFILE '"appId": "ianimal-savp-merge-sams-1.129u1",'."\n";
  			print $MFILE '"batchQueue": "normal",'."\n";
  			print $MFILE '"executionSystem": "lonestar4.tacc.teragrid.org",'."\n";
  			print $MFILE '"maxRunTime": "24:00:00",'."\n";
  			print $MFILE '"memoryPerNode": "24GB",'."\n";
  			print $MFILE '"nodeCount": 1,'."\n";
  			print $MFILE '"processorsPerNode": 12,'."\n";
  			print $MFILE '"archive": true,'."\n";
  			print $MFILE '"archiveSystem": "data.iplantcollaborative.org",'."\n";
  			print $MFILE '"archivePath": "ercfrtz/schnabel/",'."\n";
  			print $MFILE '"inputs": {'."\n";
    		print $MFILE '"inputFiles": [ '.$listOfFiles."\n";
    		print $MFILE "]\n";
  			print $MFILE "},\n";
  			print $MFILE '"parameters": {'."\n";
    		print $MFILE '"outputFile": "'.$prevBreed.'.'.$prevID.'.bam",'."\n";
    		print $MFILE '"sortOrder": "coordinate",'."\n";
    		print $MFILE '"cleanupIntermediates": true'."\n";
  			print $MFILE "},\n";
  			print $MFILE '"notifications": ['."\n";
  			print $MFILE "]\n";
			print $MFILE "}\n";
			close $MFILE;
			
			my $gatkFile = $prevBreed.".".$prevID.".savp.job.json";
			open my $GFILE, ">", $gatkFile or die("Could not open file. $!");
			print $GFILE "{\n";
    		print $GFILE '"jobName": "savp-030-01",'."\n";
    		print $GFILE '"softwareName": "ianimal-savp-0.3.0u1",'."\n";
    		print $GFILE '"processorsPerNode": 12,'."\n";
    		print $GFILE '"requestedTime": "24:00:00",'."\n";
    		print $GFILE '"memoryPerNode": 24,'."\n";
    		print $GFILE '"nodeCount": 1,'."\n";
    		print $GFILE '"batchQueue": "normal",'."\n";
    		print $GFILE '"archive": true,'."\n";
    		print $GFILE '"archivePath": "ercfrtz/schnabel",'."\n";
    		print $GFILE '"inputs": {'."\n";
        	print $GFILE '"inputBam": "agave://data.iplantcollaborative.org/path/to/output/'.$prevBreed.'.'.$prevID.'.bam",'."\n";
        	print $GFILE '"inputBamBai": "agave://data.iplantcollaborative.org/path/to/output/'.$prevBreed.'.'.$prevID.'.bam.bai",'."\n";
        	print $GFILE '"referenceBundle": "agave://data.iplantcollaborative.org/shared/iastate-tacc-genomics/umd_3_1_Y_Mito.tar",'."\n";
        	print $GFILE '"knownVariants": "agave://data.iplantcollaborative.org/shared/iastate-tacc-genomics/Bos_taurus.dbSNP.vcf"'."\n";
    		print $GFILE "},\n";
    		print $GFILE '"parameters": {'."\n";
    		print $GFILE '"regionName": "",'."\n";
    		print $GFILE '"runUnifiedGenotyper": true,'."\n";
    		print $GFILE '"runPlatypus": true,'."\n";
    		print $GFILE '"runMpileup": true,'."\n";
    		print $GFILE '"cleanupInputs": true,'."\n";
    		print $GFILE '"cleanupIntermediates": true'."\n";
    		print $GFILE "},\n";
    		print $GFILE '"outputs": {'."\n";
    		print $GFILE "}\n";
			print $GFILE "}\n";
			close $GFILE;
			
			$prevBreed = $nameBase[0];
			$prevID = $nameBase[1];
			$listOfFiles = '"agave://data.iplantcollaborative.org/path/to/output/'.$fileBaseName.'.mem.bam"';
		}
  	}
}

my $mergeFile = $prevBreed.".".$prevID.".merge.job.json";
open my $MFILE, ">", $mergeFile or die("Could not open file. $!");
print $MFILE "{\n";
print $MFILE '"name":"test-savp-merge-sams-01",'."\n";
print $MFILE '"appId": "ianimal-savp-merge-sams-1.129u1",'."\n";
print $MFILE '"batchQueue": "normal",'."\n";
print $MFILE '"executionSystem": "lonestar4.tacc.teragrid.org",'."\n";
print $MFILE '"maxRunTime": "24:00:00",'."\n";
print $MFILE '"memoryPerNode": "24GB",'."\n";
print $MFILE '"nodeCount": 1,'."\n";
print $MFILE '"processorsPerNode": 12,'."\n";
print $MFILE '"archive": true,'."\n";
print $MFILE '"archiveSystem": "data.iplantcollaborative.org",'."\n";
print $MFILE '"archivePath": "ercfrtz/schnabel/",'."\n";
print $MFILE '"inputs": {'."\n";
print $MFILE '"inputFiles": [ '.$listOfFiles."\n";
print $MFILE "]\n";
print $MFILE "},\n";
print $MFILE '"parameters": {'."\n";
print $MFILE '"outputFile": "'.$prevBreed.'.'.$prevID.'.bam",'."\n";
print $MFILE '"sortOrder": "coordinate",'."\n";
print $MFILE '"cleanupIntermediates": true'."\n";
print $MFILE "},\n";
print $MFILE '"notifications": ['."\n";
print $MFILE "]\n";
print $MFILE "}\n";
close $MFILE;
			
my $gatkFile = $prevBreed.".".$prevID.".savp.job.json";
open my $GFILE, ">", $gatkFile or die("Could not open file. $!");
print $GFILE "{\n";
print $GFILE '"jobName": "savp-030-01",'."\n";
print $GFILE '"softwareName": "ianimal-savp-0.3.0u1",'."\n";
print $GFILE '"processorsPerNode": 12,'."\n";
print $GFILE '"requestedTime": "24:00:00",'."\n";
print $GFILE '"memoryPerNode": 24,'."\n";
print $GFILE '"nodeCount": 1,'."\n";
print $GFILE '"batchQueue": "normal",'."\n";
print $GFILE '"archive": true,'."\n";
print $GFILE '"archivePath": "ercfrtz/schnabel",'."\n";
print $GFILE '"inputs": {'."\n";
print $GFILE '"inputBam": "agave://data.iplantcollaborative.org/path/to/output/'.$prevBreed.'.'.$prevID.'.bam",'."\n";
print $GFILE '"inputBamBai": "agave://data.iplantcollaborative.org/path/to/output/'.$prevBreed.'.'.$prevID.'.bam.bai",'."\n";
print $GFILE '"referenceBundle": "agave://data.iplantcollaborative.org/shared/iastate-tacc-genomics/umd_3_1_Y_Mito.tar",'."\n";
print $GFILE '"knownVariants": "agave://data.iplantcollaborative.org/shared/iastate-tacc-genomics/Bos_taurus.dbSNP.vcf"'."\n";
print $GFILE "},\n";
print $GFILE '"parameters": {'."\n";
print $GFILE '"regionName": "",'."\n";
print $GFILE '"runUnifiedGenotyper": true,'."\n";
print $GFILE '"runPlatypus": true,'."\n";
print $GFILE '"runMpileup": true,'."\n";
print $GFILE '"cleanupInputs": true,'."\n";
print $GFILE '"cleanupIntermediates": true'."\n";
print $GFILE "},\n";
print $GFILE '"outputs": {'."\n";
print $GFILE "}\n";
print $GFILE "}\n";
close $GFILE;
