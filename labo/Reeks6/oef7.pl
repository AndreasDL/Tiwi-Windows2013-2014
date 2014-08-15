use strict;
use warnings;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

my $monik = "LDAP://CN=Andreas De Lille,OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be";
my $obj   = bindObj($monik);
print $obj->{ADSPath};


sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III"){
		my $kap  = (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par;
		return Win32::OLE->GetObject($kap);
	}else{
		my $ip   = "193.190.126.71";
		my $kap  = (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://$ip/") . $par;
		my $dso  = Win32::OLE->GetObject("LDAP:");
		my $user = "";
		my $pass = "";

		return $dso->OpenDSObject($kap,$user,$pass,1);
	}
}