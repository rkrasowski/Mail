#!/usr/bin/perl 
use strict;
use warnings;

my $readDirectory = "/home/ubuntu/Mail/Read/";


opendir (my $READ , $readDirectory) or die "Can not open new directory: $!\n";
my @readFiles = grep !/^\./, readdir($READ);
close ($READ);

print "Will transfer mails from Read to New folder\n";





foreach(@readFiles)
	{
		print "$_ \n";
		my $oldFile ="/home/ubuntu/Mail/Read/$_";
		my $newFile = "/home/ubuntu/Mail/New/$_";

		rename $oldFile,$newFile;
	}
print "DONE .....\n\n";
