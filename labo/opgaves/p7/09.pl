#Je kan met dsquery geen overzicht maken die enkel de namen van de klassen  bevat. 
#Je bekomt dus elke klasse meerdere keren.
#dsquery * "dc=iii,dc=hogent,dc=be" -filter "(UserAccountControl=*)" -attr objectclass

use Win32::OLE qw(in);

@ARGV == 1 or die "geef naam van een ldapattribuut als enig argument !\n";
my $ldapattribuut = $ARGV[0];

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();
 

my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III") ; # als je niet in het domein zelf zit
   $sBase .= $RootObj->{defaultNamingContext};
my $sFilter = "($ldapattribuut=*)";
my $sAttributes = "$ldapattribuut,objectClass";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $ADOrecordset = $ADOcommand->Execute();
print "\n",$ADOrecordset->{RecordCount}," AD-objecten\n";
my %classes;
until ( $ADOrecordset->{EOF} )  {
   $objectclass=$ADOrecordset->Fields("objectClass")->{Value};
   $class=$objectclass->[-1]; #laatste element
   $classes{$class}++;
   $ADOrecordset->MoveNext();
}
$ADOrecordset->Close();
$ADOconnection->Close();
foreach $cl (in keys %classes){
   print $cl,"\n";
 }

#canonicalName is een geconstrueerd attribuut en mag niet in de filter worden opgenomen.


