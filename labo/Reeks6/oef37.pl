use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par);
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			"",
			"",
			1
		);
	}
}


foreach my $arg ("OrganizationalUnit" , "cn" , "printerName"){
	print "------------------$arg------------------\n";
	my $klas = bindObj("schema/$arg");
	foreach ("adspath","class","GUID","name","parent","Schema"){
		printf "%-20s : %s\n" , $_ , $klas->{$_};
	}

	print "het overeenkomstige reeel object heeft cn = ", $klas->get("cn") , "\n\n";
}