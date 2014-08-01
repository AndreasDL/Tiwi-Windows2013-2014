use strict;
use warnings;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

my $mail = Win32::OLE->new("CDO.Message");
   $mail->{TextBody} = "hallo";
   $mail->{Subject}  = "com";
   $mail->{From}     = "...";
   $mail->{To}		 = "...";

my $conf = $mail->{Configuration};
#set config
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver")->{Value}     = "..";
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport")->{Value} = "25";
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/sendusing")->{Value}		= "2";
$conf->Fields->Update();

#view config
print $conf->{Fields}->{Count} , " objects found";
foreach (in $conf->{Fields}){
	printf "\n%s = %s", $_->{Name},$_->{Value};
	print "\n\t",join(" / ", Win32::OLE->QueryObjectType($_));
}

$mail->send();