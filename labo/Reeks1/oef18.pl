use strict;
use warnings;
use Win32::OLE qw(in);
use Win32::OLE::Const;

$Win32::OLE::Warn = 3;

my  $mail = Win32::OLE->new("CDO.Message");
	$mail->{TextBody} = "Hello from perlScript";
	$mail->{Subject}  = "COM";
	$mail->{From}	  = "...";
	$mail->{To} 	  = "...";
my  $conf = Win32::OLE->new("CDO.Configuration");
my  $wd   = Win32::OLE::Const->Load($conf);

#set the SMTPServer by using the $wd to get the property name (http.../../...) of SMTPServer
	$conf->{$wd->{cdoSMTPServer}} = "smtp.hogent.be"; #server won't work from outside
	$conf->{$wd->{cdoSendUsingMethod}} = $wd->{cdoSendUsingPort};
	$conf->{$wd->{cdoSMTPConnectionTimeout}} = 25;
	$conf->{Fields}->Update();

	$mail->{Configuration} = $conf;
	$mail->Send();