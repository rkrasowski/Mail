#!/usr/bin/perl 
use strict;
use warnings;




my $newDirectory = "/home/ubuntu/Mail/New/";
my $readDirectory = "/home/ubuntu/Mail/Read/";


opendir (my $NEW , $newDirectory) or die "Can not open new directory: $!\n";
my @newFiles = grep !/^\./, readdir($NEW);
close ($NEW);

print "     Press 1 to check New Mail\n     Press 2 to check Read Mail\n     Press 3 to write Mail\n     Press X to exit\n\n";
my $newFiles;


while(<>)
	{
		if ($_ == 1)
			{
				
				print " Your new emails:\n";
				my $smsNum = 1;
				foreach(@newFiles)
					{
						print "Mail number $smsNum : $_\n";
						$smsNum++;

					}
				
				print "Enter email number that you want to read and press ENTER\n";
				
				while(<>)
					{
						my $arrayNum = $_ - 1;
						my $sms = `cat /home/ubuntu/Mail/New/$newFiles[$arrayNum]`;
						print "Your email number $_:\n$sms\n\nPress X to returm the menu\nPress email number to read another email\n\n";


					}


			}
	}


