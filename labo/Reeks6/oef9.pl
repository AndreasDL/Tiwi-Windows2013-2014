use strict;
use warnings;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

my $obj = bindObj("CN=Andreas De Lille,OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be");

printf "%-20s : %s\n",$_ , $obj->{$_} foreach qw (mail givenName sn displayName homeDirectory scriptPath profilePath logonHours userWorkstations);



sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par );
	}else{
		my $ip   = "193.190.126.71";
		my $dso = Win32::OLE->GetObject("LDAP:");
		return $dso->OpenDSObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://$ip/") . $par,"","", 1);
	}
}
