#!/usr/bin/perl 
use strict;
use warnings;

use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

my $newDirectory = "/home/ubuntu/Mail/New/";
my $readDirectory = "/home/ubuntu/Mail/Read/";
my $commandsDirectory = "/home/ubuntu/Mail/Commands/";
my $numDisplayed = 2;


STARTMESSAGES:

opendir (my $NEW , $newDirectory) or die "Can not open new directory: $!\n";
my @newFiles = grep !/^\./, readdir($NEW);
@newFiles = sort @newFiles;
close ($NEW);


opendir (my $READ , $readDirectory) or die "Can not open new directory: $!\n";
my @readFiles = grep !/^\./, readdir($READ);
@readFiles = sort @readFiles;
close ($READ);


my @totalArray = (@newFiles,@readFiles);
my $unreadNumber = @newFiles;
my $totalNumber = @totalArray;
my $totalArray;
my $readNumber = @readFiles;

print " Total message number : $totalNumber\n\n";

START:

print BOLD BLUE "\nMESSAGES MENAGER\n\n     Press N to check NEW Messages\n     Press O  to check OLD  Messages\n     Press W ro write new message\n     Press C for COMMAND'S log\n     Press X to exit\n\n";
my $newFiles;


while(<>)
	{
		

# Reading old messages
		  if ($_=~ m/o/i)
                        {
                                my $i = 1;
                                my $j = $i + $numDisplayed;
				print "\nOld messages from $i - $j:\n\n";

				OLDDISPLAY:
				my $sumNumDisplayed = $i + $numDisplayed;
				for ($i; $i <=$sumNumDisplayed; $i++)
                                                        {	
								if($readFiles[$i-1])
									{
										print BOLD YELLOW  "Old message number $i: $readFiles[$i-1]\n";
									}
								
                                                        }
				
				print BOLD BLUE "\n     Enter message number that you want to read\n";
					
				if($i < $readNumber)
					{
						print BOLD BLUE "     Press M to see more old messages\n";
					}


				print BOLD BLUE "     Press x to return to the main menue\n";
				print "\n";
			while(<>)
				{
					# Read message
					if ($_ =~ m/[0-9]/)
						{
							chomp $_;
							print BOLD GREEN "Old message number $_:\n\n";
							my $oldMessage = `cat /home/ubuntu/Mail/Read/$readFiles[$_-1]`;
							chomp $oldMessage;
							print BOLD YELLOW "\""."$oldMessage"."\""."\n";
						}

					# Show More messages
					if ($_ =~ m/m/i)
                                                {
						
							goto OLDDISPLAY;


						}
				}
                        }


# Reading new messages

		if ($_ =~ m/N/i)
			{

				if ($numDisplayed >= $totalNumber)
					{
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
			   			print BOLD BLUE "\n\n      Enter message number that you want to read and press ENTER\n";

		
					}

				my $sep;
				if ($numDisplayed < $totalNumber)
					{
						print "Last 10 mesages:\n\n";
						
						for ($sep = 1; $sep <=$numDisplayed; $sep++)
							{
                                                                print BOLD RED "Unread message number $sep: $newFiles[$sep-1]\n";
                                                        }
						print "Sep is $sep\n\n";
						
						print BOLD BLUE "\n\n     Enter message number that you want to read\n     Press M to see more messages\n\n";
									
						        
					}


				ONLY10:
			
				while(<>)
					{
						

						if ($_ =~ m/m/i)
							{
								my $nextNum = $sep + $numDisplayed;
								print "Messages $sep  - $nextNum\n";
								
								for ( $sep; $sep<=$nextNum; $sep++)
                                                        		{
                                                                		print BOLD RED "Unread message number $sep: $newFiles[$sep-1]\n";
										if ($_ =~ m//)
											{
												goto READMESSAGES;
											}
                                                        		}
                                                print "Sep is $sep\n\n";
						print BOLD BLUE "\n\n     Enter message number that you want to read\n     Press M to see more messages\n\n";
						goto ONLY10;


						READMESSAGES: {print "All new messages\n";}

								
							}
					

						elsif ($_ <= $unreadNumber)
							{
								my $arrayNum = $_ - 1;
								my $sms = `cat /home/ubuntu/Mail/New/$newFiles[$arrayNum]`;

								# move message to Read folder 
                                                                rename "/home/ubuntu/Mail/New/$newFiles[$arrayNum]","/home/ubuntu/Mail/Read/$newFiles[$arrayNum]";
								
								my $messageNumber = $_;
                                                                chomp $messageNumber;
								
								print "\nYour message  number $messageNumber:\n\n";
								print BOLD YELLOW "$sms\n\n";
								print BOLD BLUE "     Press 1 to reply to this message\n     Press 2 to return to Main Menu\n     Press x to erase this message\n\n";
								while(<>)
									{
										if ($_ =~ m/1/)
											{
												print BOLD GREEN "Write your message and press ENTER\n";
											}

										if ($_=~ m/2/)
											{
												goto START;
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

                                                                                                                                goto START;
                                                                                                                        }
                                                                                                                if ($_  =~ m/N/i)
                                                                                                                        {
                                                                                                                                print "Message number $messageNumber NOT delated\n\n";
                                                                                                                                goto START;
                                                                                                                        }
                                                                                                                else {print "Try again , Y or N\n\n";}

                                                                                                        }

											}
										else {print "Try again, 1, 2 or x only\n\n";}
									}
							}
						
						elsif ($_ > $unreadNumber and $_ <= $totalNumber)
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
		



		if ($_ =~ m/w/i)
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


