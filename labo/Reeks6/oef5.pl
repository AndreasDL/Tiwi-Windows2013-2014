use strict;
use warnings;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

my $monik = "LDAP://193.190.126.71/CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be";
my $obj   = bindObj($monik);
print Win32::OLE->LastError()?"not ok":"ok" , "\n";

my $pater = "CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be";
my $objj  = bindObj($pater);
print Win32::OLE->LastError()?"not ok":"ok" , "\n";

sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III"){
		my $kap  = (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par;
		return Win32::OLE->GetObject($kap);
	}else{
		my $ip   = "193.190.126.71";
		my $kap  = (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://$ip/") . $par;
		my $dso  = Win32::OLE->GetObject("LDAP:");
		my $user = "...";
		my $pass = "...";
		return $dso->OpenDSObject($kap,$user,$pass,1);
	}
}