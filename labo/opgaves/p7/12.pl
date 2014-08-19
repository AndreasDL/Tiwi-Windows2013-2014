#dsquery * "cn=schema,cn=configuration,dc=iii,dc=hogent,dc=be" -filter "(ldapdisplayname=cn)" -attr name

use Win32::OLE qw(in);
@ARGV == 1 or die "geef de ldapdisplayName als enig argument !\n";
my $ldapdisplayname = $ARGV[0];


my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = " ... "; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = " ... "; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();


my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III") ; # als je niet in het domein zelf zit
   $sBase .= $RootObj->{schemaNamingContext};
my $sFilter = "(ldapdisplayname=$ldapdisplayname)";
my $sAttributes = "adspath"; #of name
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $ADOrecordset = $ADOcommand->Execute();
until ( $ADOrecordset->{EOF} )  {
   print $ADOrecordset->Fields("adspath")->{Value},"\n";
   $ADOrecordset->MoveNext();
}
   $ADOrecordset->Close();
   $ADOconnection->Close();


#Je kan dit ook als volgt ophalen, zonder LDAP-query (zie reeks 6 oefening 36)
my $abstracteKlasse  = bind_object( "schema/$ldapdisplayname" );
print "\nHet overeenkomstig reeel object heeft cn=",$abstracteKlasse->get("cn");



