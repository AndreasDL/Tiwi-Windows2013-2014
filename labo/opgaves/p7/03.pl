
my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");        # als je niet in het domein zelf zit
   $sBase .= "DC=iii,DC=hogent,DC=be";
my $sFilter     = "(&(objectCategory=printQueue)(printColor=TRUE)(printDuplexSupported=TRUE))";
my $sAttributes = "printMaxXExtent,whenChanged,printStaplingSupported,objectClass,printername,adspath,objectGUID";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "printerName";


