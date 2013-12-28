#!/usr/bin/perl 
use strict;
use warnings;

use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;



my $newDirectory = "/home/ubuntu/Mail/New/";
my $readDirectory = "/home/ubuntu/Mail/Read/";
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

print BOLD BLUE "\nMESSAGES MENAGER\n     Press 1 to check Messages\n     Press 2 to write Message\n     Press X to exit\n\n";
my $newFiles;


while(<>)
	{
		if ($_ == 1)
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
		

								chomp $_;
								print "\nYour message  number $_:\n\n";
								print BOLD YELLOW "$sms\n\n";
								print BOLD BLUE "Press 1 to reply to this message\nPress 2 to return to messages list\nPress 3 to erase this message\n\n";
								while(<>)
									{
										if ($_ == 1)
											{
												print BOLD GREEN "Write your message and press ENTER\n";
											}

										if ($_== 2)
											{
												goto STARTMESSAGES;
											}
										if ($_== 3)
											{
												print BOLD RED "Are you sure, you want to delay that message? Press Y or N !!\n\n";
												while(<>)
													{
														if ($_ =~ m/Y/)	
															{
																print "Message dalated\n\n";
																goto STARTMESSAGES;
															}
														if ($_  =~ m/N/)
															{
																print "Message NOT delated\n\n";
																goto STARTMESSAGES;
															}
														else {print "Try again , Y or N\n\n";}
													
													}
											}
										else {print "Try again, 1, 2 or 3 only\n\n";}
									}
							}
						
						if ($_ > $unreadNumber and $_ <= $totalNumber)
                                                        {
                                                                my $arrayNum = $_ - 1 - $unreadNumber;
                                                                my $sms = `cat /home/ubuntu/Mail/Read/$readFiles[$arrayNum]`;
                                                                chomp $_;
                                                                print "\nur message  number $_:\n\n";
                                                                print BOLD YELLOW "$sms\n\n";
                                                                print BOLD BLUE "Press 1 to reply to this message\nPress 2 to return to messages list\nPress x to erase this message\n\n";
                                                        }
						else { print "Wrong number\n";}
					}


			}
	}


