#!/usr/bin/perl 
use strict;
use warnings;

use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

my $newDirectory = "/home/ubuntu/Mail/New/";
my $readDirectory = "/home/ubuntu/Mail/Read/";
my $commandsDirectory = "/home/ubuntu/Mail/Commands/";
my $numDisplayed = 10;


STARTMESSAGES:

opendir (my $NEW , $newDirectory) or die "Can not open new directory: $!\n";
my @newFiles = grep !/^\./, readdir($NEW);
close ($NEW);


opendir (my $READ , $readDirectory) or die "Can not open new directory: $!\n";
my @readFiles = grep !/^\./, readdir($READ);
close ($READ);


my @totalArray = (@newFiles,@readFiles);
my $unreadNumber = @newFiles;
my $totalNumber = @totalArray;
my $totalArray;

print " Total message number : $totalNumber\n\n";


print BOLD BLUE "\nMESSAGES MENAGER\n\n     Press 1 to check Messages\n     Press 2 to write Message\n     Press C for COMMAND'S log\n     Press X to exit\n\n";
my $newFiles;


while(<>)
	{
		if ($_ =~ m/1/)
			{	MESSAGEMENAGER:
				
				print "Messages:\n\n";
				my $smsNum = 1;
					
				my $i;
				my $j;
				
				for ($i = 1; $i <=$unreadNumber; $i++)
					{
						print BOLD RED "Unread message number $i: $newFiles[$i-1]\n";
					}
				for ($j = $unreadNumber+1; $j<= $totalNumber; $j++)
					{			
						print BOLD YELLOW"Old message number $j: $totalArray[$j-1]\n"; 

					}
			   	print "\nEnter message number that you want to read and press ENTER\n";
				
				while(<>)
					{
						if ($_ <= $unreadNumber)
							{
								my $arrayNum = $_ - 1;
								my $sms = `cat /home/ubuntu/Mail/New/$newFiles[$arrayNum]`;

								# move message to Read folder 
                                                                rename "/home/ubuntu/Mail/New/$newFiles[$arrayNum]","/home/ubuntu/Mail/Read/$newFiles[$arrayNum]";
								
								my $messageNumber = $_;
                                                                chomp $messageNumber;
								
								print "\nYour message  number $messageNumber:\n\n";
								print BOLD YELLOW "$sms\n\n";
								print BOLD BLUE "     Press 1 to reply to this message\n     Press 2 to return to messages list\n     Press x to erase this message\n\n";
								while(<>)
									{
										if ($_ =~ m/1/)
											{
												print BOLD GREEN "Write your message and press ENTER\n";
											}

										if ($_=~ m/2/)
											{
												goto STARTMESSAGES;
											}
										if ($_=~ m/x/i)
											{

												print BOLD RED "Are you sure, you want to delay message number $messageNumber? Press Y or N !!\n\n";
                                                                                                while(<>)
                                                                                                        {
                                                                                                                if ($_ =~ m/Y/i)
                                                                                                                        {
                                                                                                                                print "Message number $messageNumber dalated\n\n";
                                                                                                                                unlink "/home/ubuntu/Mail/Read/$newFiles[$arrayNum]";

                                                                                                                                goto STARTMESSAGES;
                                                                                                                        }
                                                                                                                if ($_  =~ m/N/i)
                                                                                                                        {
                                                                                                                                print "Message number $messageNumber NOT delated\n\n";
                                                                                                                                goto STARTMESSAGES;
                                                                                                                        }
                                                                                                                else {print "Try again , Y or N\n\n";}

                                                                                                        }

											}
										else {print "Try again, 1, 2 or x only\n\n";}
									}
							}
						
						if ($_ > $unreadNumber and $_ <= $totalNumber)
                                                        {
                                                                my $arrayNum = $_ - 1 - $unreadNumber;
                                                                my $sms = `cat /home/ubuntu/Mail/Read/$readFiles[$arrayNum]`;
                                                                my $messageNumber = $_;
								chomp $messageNumber;
                                                                print "\nYour message  number $messageNumber:\n\n";
                                                                print BOLD YELLOW "$sms\n\n";
                                                                print BOLD BLUE "     Press 1 to reply to this message\n     Press 2 to return to messages list\n     Press x to erase this message\n\n";

								  while(<>)
                                                                        {
                                                                                if ($_ =~ m/1/)
                                                                                        {
                                                                                                print BOLD GREEN "Write your message and press ENTER\n";
                                                                                        }

                                                                                if ($_=~ m/2/)
                                                                                        {
                                                                                                goto STARTMESSAGES;
                                                                                        }
                                                                                if ($_ =~ m/x/i)
                                                                                        {
                                                                                                print BOLD RED "Are you sure, you want to delay message number $messageNumber? Press Y or N !!\n\n";
                                                                                                while(<>)
                                                                                                        {
                                                                                                                if ($_ =~ m/Y/i)
                                                                                                                        {
                                                                                                                                print "Message number $messageNumber dalated\n\n";
																unlink "/home/ubuntu/Mail/Read/$readFiles[$arrayNum]";

                                                                                                                                goto STARTMESSAGES;
                                                                                                                        }
                                                                                                                if ($_  =~ m/N/i)
                                                                                                                        {
                                                                                                                                print "Message number $messageNumber NOT delated\n\n";
                                                                                                                                goto STARTMESSAGES;
                                                                                                                        }
                                                                                                                else {print "Try again , Y or N\n\n";}

                                                                                                        }
                                                                                        }
                                                                                else {print "Try again, 1, 2 or x only\n\n";}
                                                                        }

                                                        }
						else { print "Wrong number\n";}
					}


			}
		
		if ($_ =~ m/2/)
			{
				print "Compose the message:\nEnter destination:\n\n";
			}
		
		if ($_ =~ m/c/i)
                        {
                		opendir (my $COMMANDS , $commandsDirectory) or die "Can not open new directory: $!\n";
				my @commandsFiles = grep !/^\./, readdir($COMMANDS);
				close ($COMMANDS);               
				my $commandsNumber = @commandsFiles;
				my $commandsFiles;
				my $i = 1;
				
				
				print BOLD BLUE "COMMAND's LOG\n\n";
				
				foreach (@commandsFiles)
					{
						print BOLD GREEN "Command number $i: $_\n";
						$i++;
					}
				print "\n";
				READINGCOMMANDSFIRST:
				print BOLD BLUE "     Enter command number that you want to read\n     Press X to exit\n\n";
				while(<>)
					{
						if ($_ =~ m/x/i)
							{
								goto STARTMESSAGES;
							}
	
						if ($_ =~ m/[0-$commandsNumber]/)

						
							{
								  READINGCOMMANDS:

								my $commands = `cat /home/ubuntu/Mail/Commands/$commandsFiles[$_ - 1]`;
								print BOLD YELLOW "$commands\n\n";		
			
								print BOLD BLUE "Enter different number to read different command\n\nPress X to go to main menu\n\n";
								while(<>)
									{
										if ($_ =~ m/[0-$commandsNumber]/)
											{
												goto READINGCOMMANDS;
											}
										if ($_ =~ m/x/i)
											{
												goto STARTMESSAGES;
											}
										else
											{
												print BOLD RED "Ups, try again ....\n";
												goto READINGCOMMANDSFIRST;
											}
									}								
								
										
							}
						else 
							{
								print BOLD RED "Ups, try again\n";
								goto READINGCOMMANDSFIRST;
							}

					}

                        }





		 if ($_ =~ m/x/i)
                        {
                                print "Exiting.....\n\n";
				exit();
                        }


	}


