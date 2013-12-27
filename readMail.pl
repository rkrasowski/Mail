#!/usr/bin/perl 
use strict;
use warnings;

use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;



my $newDirectory = "/home/ubuntu/Mail/New/";
my $readDirectory = "/home/ubuntu/Mail/Read/";


opendir (my $NEW , $newDirectory) or die "Can not open new directory: $!\n";
my @newFiles = grep !/^\./, readdir($NEW);
close ($NEW);


opendir (my $READ , $readDirectory) or die "Can not open new directory: $!\n";
my @readFiles = grep !/^\./, readdir($READ);
close ($READ);


my @totalArray = (@newFiles,@readFiles);
my $unreadNumber = @newFiles;
print "Unread number :$unreadNumber\n\n";


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
						chomp $_;
						print "Your email number $_:\n";
						print BOLD YELLOW "$sms\n\n";
						print BOLD BLUE "Press X to returm the menu\nPress email number to read another email\n\n";


					}


			}
	}


