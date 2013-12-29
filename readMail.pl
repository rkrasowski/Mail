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
@newFiles = sort @newFiles;
close ($NEW);


opendir (my $READ , $readDirectory) or die "Can not open new directory: $!\n";
my @readFiles = grep !/^\./, readdir($READ);
@readFiles = sort @readFiles;
close ($READ);


my @totalArray;
my $totalArray;
my $totalNumber;

my $unreadNumber;

my $readNumber;


START:

print BOLD BLUE "\nMESSAGES MENAGER\n\n     Press M to check Messages\n     Press W ro write new message\n     Press C for COMMAND'S log\n     Press X to exit\n\n";
my $newFiles;


while(<>)
	{
		

	# Reading messages
		 if ($_=~ m/M/i)
                        {
                                my $i = 1;
                                
				DISPLAY:

			# Check new messages
				opendir (my $NEW , $newDirectory) or die "Can not open new directory: $!\n";
				my @newFiles = grep !/^\./, readdir($NEW);
				@newFiles = sort @newFiles;
				close ($NEW);
			# Check Read messages
				opendir (my $READ , $readDirectory) or die "Can not open new directory: $!\n";
				my @readFiles = grep !/^\./, readdir($READ);
				@readFiles = sort @readFiles;
				close ($READ);
			# Create variables
				@totalArray = (@newFiles,@readFiles);
				$totalNumber = @totalArray;
				$unreadNumber = @newFiles;
				$readNumber = @readFiles;

				

				my $j = $i + $numDisplayed;

				print "\nMessages from $i - $j:\n\n";

				my $sumNumDisplayed = $i + $numDisplayed;
				for ($i; $i <=$sumNumDisplayed; $i++)
                                                        {	
								if($totalArray[$i-1])
									{
										if ($i <= $unreadNumber)
											{
												print BOLD RED "NEW message number $i: $totalArray[$i-1]\n";
											}
										else
											{
												print BOLD YELLOW  "Old message number $i: $totalArray[$i-1]\n";
											}
									}
								
                                                        }
				
				print BOLD BLUE "\n     Enter message number that you want to read\n";
					
				if($sumNumDisplayed < $totalNumber)
					{
						print BOLD BLUE "     Press M to see more old messages\n";
					}


				print BOLD BLUE "     Press X to return to the main menu\n";
				print "\n";

				while(<>)
					{
					# Read message
					if ($_ =~ m/[0-9]/)
						{
							chomp $_;
							my $messageNumber;
					
							# Reading NEW messages
							if($_ <= $unreadNumber)
								{
									print "New messages\n";
									$messageNumber = $_;
									print BOLD GREEN "New message number $_:\n\n";
									my $newMessage = `cat /home/ubuntu/Mail/New/$totalArray[$_-1]`;
									chomp $newMessage;
									print BOLD YELLOW "\""."$newMessage"."\""."\n\n";
									# Moving New message  to Read folder
									rename "/home/ubuntu/Mail/New/$newFiles[$messageNumber-1]","/home/ubuntu/Mail/Read/$newFiles[$messageNumber -1]";  
								}

							else 
							# Reading old message
								{
									print "In old messages\n";
									$messageNumber = $_;
                                                                        print BOLD GREEN "Message number $_:\n\n";
                                                                        my $oldMessage = `cat /home/ubuntu/Mail/Read/$totalArray[$_-1]`;
                                                                        chomp $oldMessage;
                                                                        print BOLD YELLOW "\""."$oldMessage"."\""."\n\n";
								}


							# After reading message;
							print BOLD BLUE "     Press R to Replay to this message\n     Press D to delate this message\n     Press X to return to messages list\n     Press Q to return to mail menu\n\n";
							while (<>)
								{
									if ($_ =~ m/r/i)
										{
											# Replay
											REPLAY:
											print BOLD GREEN "REPLAY TO MESSAGE:\n\n";
											print BOLD BLUE "Write text and press ENTER\n\n";
											while(<>)
												{
													my $text = "";
													$text = $text.$_;
													chomp $text;
													my @charNum = split(//,$text);
													my $numChar = @charNum;
													print "Your text: $text\nNumber of characters is: $numChar\n\n";
													REPLAYRESPONSE:
													print BOLD BLUE "     Press Y to send it\n     Press N to write message again\n     Press X to returm\n\n";
													while(<>)
													{
														if($_ =~ m/y/i)
															{
																print BOLD RED "Message sent !!\n\n";
																$sumNumDisplayed = $sumNumDisplayed - $numDisplayed - 1;
        					                                                                                $i = $i - $numDisplayed - 1;
																goto DISPLAY;
															}
														elsif($_ =~ m/n/i)
															{
																goto REPLAY;
															}
														 elsif($_ =~ m/x/i)
                                                                                                                        {
                                                                                                                                $sumNumDisplayed = $sumNumDisplayed - $numDisplayed - 1;
					                                                                                        $i = $i - $numDisplayed - 1;
																goto DISPLAY;
                                                                                                                        }
														else 
															{
																print BOLD RED "Uhh? Y, N or X only, try again\n\n";
																goto REPLAYRESPONSE;
															}



													}
												}
													

	
										}
									if ($_ =~ m/d/i)
										{
											# Delate 
											    print BOLD RED "Are you sure, you want to delay message number $messageNumber? Press Y or N !!\n\n";
                                                                                                while(<>)
                                                                                                        {
                                                                                                                if ($_ =~ m/Y/i)
                                                                                                                        {
                                                                                                                                print "Message number $messageNumber dalated\n\n";
																if ($messageNumber <= $unreadNumber)
																	{
                                                                                                                       			         unlink "/home/ubuntu/Mail/New/$newFiles[$messageNumber -1]";
																	}
																else
																	{

																	}

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

									if ($_ =~ m/x/i)
										{
											# Return 
											$sumNumDisplayed = $sumNumDisplayed - $numDisplayed - 1;
											$i = $i - $numDisplayed - 1;

											goto OLDDISPLAY; 
										}

									 if ($_ =~ m/q/i)
                                                                                {
                                                                                        # Main menu
                                                                                        goto STARTMESSAGES;
                                                                                }
								}
						}

					# Show More messages
					if ($_ =~ m/m/i)
                                                {
							#print BOLD RED "No more old messages\n\n";
							goto DISPLAY;


						}

					if ($_ =~ m/x/i)
                                                {
                                                 
                                                        goto STARTMESSAGES;
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


