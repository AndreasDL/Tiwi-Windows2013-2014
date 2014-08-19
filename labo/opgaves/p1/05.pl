use Win32::OLE;

$cdo = Win32::OLE->new("CDO.Message");

$Count = Win32::OLE->EnumAllObjects(
   sub {
       my $Object = shift;
       printf "\n%-30s : %s",ref($Object),join(" / ",Win32::OLE->QueryObjectType($Object));
   }
 );
print "\n$Count OLE-objecten geladen\n";

