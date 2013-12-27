#!/usr/bin/perl 
use strict;
use warnings;

my $newDirectory = "/home/ubuntu/Mail/New/";



print "Mail reader started.\n";




opendir (my $NEW , $newDirectory) or die "Can not open new directory: $!\n";
my @newFiles = grep !/^\./, readdir($NEW);

my $smsNum = 1;
foreach(@newFiles)
	{
		print "Mail number $smsNum : $_\n";
		$smsNum++;
	}



close ($NEW);

