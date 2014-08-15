use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $users = bindObj("CN=Users,dc=iii,dc=hogent,dc=be");
foreach (in $users){
	print $_->{adspath} , "\n";
}

my $admin = $users->GetObject("user","CN=Administrator");
print $admin->{ADsPath};


sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par );
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			"",
			"",
			1
		);
	}
}