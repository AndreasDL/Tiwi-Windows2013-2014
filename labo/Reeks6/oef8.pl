use strict;
use warnings;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

my $monik = "LDAP://193.190.126.71/CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be";
my $obj   = bindObj($monik);

print "--------------------ADSI-------------------------------\n";
print  "Adspath (ADSI) = " ;
printinhoud ($obj->{ADsPath});

print  "class (ADSI)   = ";
printinhoud ($obj->{class});

print  "GUID (ADSI)    = ";
printinhoud ($obj->{GUID});

print "--------------------LDAP-------------------------------\n";
print  "distinguishedName (LDAP) = " ;
printinhoud ($obj->{distinguishedName});

print  "objectclass (LDAP)       = ";
printinhoud ($obj->{objectclass});

print  "objectGUID (LDAP)        = ";
printinhoud (sprintf ("%*v02X ","",$obj->{objectGUID}));






sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par );
	}else{
		my $ip   = "193.190.126.71";
		my $kap  = (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://$ip/") . $par;
		my $dso  = Win32::OLE->GetObject("LDAP:");
		my $user = "";
		my $pass = "";

		return $dso->OpenDSObject($kap,$user,$pass,1);
	}

}

sub printinhoud{
   my $inhoud=shift;
   if (ref $inhoud) {
       print "Array met " , scalar @{$inhoud} , " elementen :\n\t" ;
       print join("\n\t", @{$inhoud});
   }
   else {
       print "$inhoud";
   }
   print "\n";
}