use Win32::OLE qw(in);

my $obj=bind_object("LDAP://193.190.126.71/CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be");
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

sub bind_object{
   my $moniker=shift;
   my $dso = Win32::OLE->GetObject("LDAP:")   ;
   my $loginnaam = ".....";         #vul in
   my $paswoord  = ".....";         #vul in
#   print "Moniker        : $moniker\n";
   return $dso->OpenDSObject($moniker, $loginnaam, $paswoord, 1);
}

