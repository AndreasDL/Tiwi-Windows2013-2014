use Win32::OLE qw(in);

$obj=bind_object ("LDAP://iii.hogent.be/CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be");
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

sub bind_object{
   my $moniker=shift;
   my $dso = Win32::OLE->GetObject("LDAP:")   ;
   my $loginnaam = ".....";         #vul in
   my $paswoord  = ".....";         #vul in
#   print "Moniker        : $moniker\n";
   return $dso->OpenDSObject($moniker, $loginnaam, $paswoord, 1);
}