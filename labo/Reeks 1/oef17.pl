use strict;
use warnings;
use Win32::OLE qw(in);
use Win32::OLE::Const;

$Win32::OLE::Warn = 3;

my $conf = Win32::OLE->new("CDO.Configuration");
my $map = Win32::OLE::Const->Load($conf);
   
#get the config paramNames
my $sendMethod = $map->{cdoSendUsingMethod};
my $sendPort   = $map->{cdoSendUSingPort};
my $smtpServer = $map->{cdoSMTPServer};

#set config
$conf->Fields($sendMethod)->{value} = $sendPort;
$conf->Fields($smtpServer)->{value} = "smtp.hogent.be"; #server won't work from the outside!

#print config
foreach (in $conf->{Fields}){
	print "\n\nName : ", $_->{Name}, "\n\tValue : ", $_->{Value};
}