#. . . implementatie functie bind_object zie sectie 5 in reeks 6
#. . . implementatie functie valueattribuut: zie oefening 1

use Win32::OLE qw(in);
#$Win32::OLE::Warn = 3;

@ARGV == 1 or die "geef als enige parameter de SamAccountName van de user\n";
my $user = $ARGV[0];

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . . "; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();


my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");        # als je niet in het domein zelf zit
   $sBase .= $RootObj->{defaultNamingContext});
my $sFilter     = "(&(objectcategory=person)(objectclass=user))";
my $sAttributes = "adspath,samAccountName";
my $sScope      = "subtree";

   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
my $ADOrecordset = $ADOcommand->Execute();

my %lijst;
until ( $ADOrecordset->{EOF} ) {
    $lijst{lc($ADOrecordset->Fields("samaccountname")->{Value})}
             =$ADOrecordset->Fields("adspath")->{Value};
    $ADOrecordset->MoveNext();
}

$ADOrecordset->Close();


my %samlijst,%userlijst,%groeplijst;

sub groepenlijst {
  $sFilter     = "(objectcategory=group)";
  $sAttributes = "samaccountname,adspath,objectclass";
  $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";


  my $ADOrecordset = $ADOcommand->Execute();
  until ( $ADOrecordset->{EOF} ) {

      my $adsPath=$ADOrecordset->Fields("adsPath")->{Value};
      my $samAccountName=lc($ADOrecordset->Fields("samAccountName")->{Value});
      $groeplijst{$samAccountName}=$adsPath;
      $ADOrecordset->MoveNext();
   }

  $ADOrecordset->Close();
}

sub lijsten_maken{
  $sFilter     = "(samAccountName=*)";
  $sAttributes = "samAccountName,adsPath,objectclass";
  $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
  my $ADOrecordset = $ADOcommand->Execute();

  until ( $ADOrecordset->{EOF} ) {
      my $adsPath=$ADOrecordset->Fields("adsPath")->{Value};
      my $samAccountName=lc($ADOrecordset->Fields("samAccountName")->{Value});
      my $objectclass=$ADOrecordset->Fields("objectclass")->{Value};
      $samlijst{$samAccountName}=$adsPath;
      $userlijst{$samAccountName}=$adsPath if $objectclass->[$#{$objectclass}] eq "user";
      $ADOrecordset->MoveNext();
   }

  $ADOrecordset->Close();

  groepenlijst();
}

lijsten_maken();

while ((my $key,$value)=each(%groeplijst)){
   printf "\n%s\t:%s",$key,$value;
}

$ADOconnection->Close();




