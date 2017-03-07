#! /usr/local/bin/perl
use strict;
use File::Basename;
use XML::Twig;
#use warnning;
#use DateTime;  

my $logfile = "build.log"; 
my %mod_mail
initlog();
readcmdconfig("config_cmd.xml");




# open(FILElog, "<$logfile"); # reading file
# while (<FILElog>){
	# print "$_";
# }

# print "\n";



sub readcmdconfig{
	my $xmlfile = shift(@_);
	#print "configure file is $xmlfile\n";
	my $xmlhandle = XML::Twig->new();
	$xmlhandle->parsefile("$xmlfile");
	my $root = $xmlhandle->root();	
	my @cmdline = $root->children('cmd');
	foreach my $eachcmd(@cmdline){
		my $cmdoutput = $eachcmd->{'att'}->{'line'};
		printlog($cmdoutput);
		my @list = $eachcmd->children('list');
		foreach my$eachlist(@list){
			my $listmodual= $eachlist->{'att'}->{'modulepath'};
			printlog($listmodual);
		}
	
	}
}

sub readmailconfig{
	my $xmlfile = shift (@_);
	my $xmlhandle = XML::Twig->new();
	$xmlhandle->parsefile("config_mail.xml");
	my @module_list= $xmlhandle->children('module");
}





sub initlog{

	my $today=&getTime();
	#my $daystring= $today->{year}+$today->{month}+$today->{day};
	$logfile= 'build_'.$today->{date}.'.log';
	print "$logfile\r\n";
	#my $logfile = "build.log";
	if(-e $logfile){
		print "$logfile already exists, delete it!\r\n";
		unlink $logfile;
	}
	
	if(open(LOGFILE, ">$logfile")){
		print "Create $logfile\r\n";
		print LOGFILE "Create $logfile\r\n";
		close(LOGFILE);
	}
	else{
		print "$logfile can not created\r\n";
		exit(1);
	}

}
sub printlog{

	my $logstr= shift(@_);
	print("$logstr\r\n");
	if(-e $logfile){
	
		if(open(LOGFILE, ">$logfile")){
			print(LOGFILE "$logstr\r\n");
			close(LOGFILE);		
		}
		else{
			print("function printlog : $logfile is exists but can not open\r\n");
		}	
		
	}
	else{
		print("function printlog : $logfile is not exist\r\n");
	}


}

sub getTime
{
   #time()函数返回从1970年1月1日起累计秒数
    my $time = shift || time();
   
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
   
    $mon ++;
    $sec  = ($sec<10)?"0$sec":$sec;#秒数[0,59]
    $min  = ($min<10)?"0$min":$min;#分数[0,59]
    $hour = ($hour<10)?"0$hour":$hour;#小时数[0,23]
    $mday = ($mday<10)?"0$mday":$mday;#这个月的第几天[1,31]
    $mon  = ($mon<9)?"0".$mon:$mon;#月数[0,11],要将$mon加1之后，才能符合实际情况。
    $year+=1900;#从1900年算起的年数
   
    #$wday从星期六算起，代表是在这周中的第几天[0-6]
    #$yday从一月一日算起，代表是在这年中的第几天[0,364]
  # $isdst只是一个flag
    my $weekday = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[$wday];
    return { 'second' => $sec,
             'minute' => $min,
             'hour'   => $hour,
             'day'    => $mday,
             'month'  => $mon,
             'year'   => $year,
             'weekNo' => $wday,
             'wday'   => $weekday,
             'yday'   => $yday,
             'date'   => "$year$mon$mday"
          };
}



