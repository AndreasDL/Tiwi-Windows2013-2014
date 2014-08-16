use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $ldapAttr = "UserAccountControl";
#"postalCode";


my $con = Win32::OLE->CreateObject("ADODB.Connection");
   $con->{Provider} = "ADsDSOObject";
   $con->{Properties}->{"User ID"} = "";
   $con->{Properties}->{"Password"} = "";
   $con->{Properties}->{"Encrypt Password"} = 1;
   $con->Open();
my $cmd = Win32::OLE->CreateObject("ADODB.Command");
   $cmd->{ActiveConnection} = $con;
   $cmd->{Properties}->{"Page Size"} = 20;

my $rootDSE = bindObj("rootDSE");

my $base   = "LDAP://";
   $base  .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");
   $base  .= $rootDSE->Get("defaultNamingContext");
my $filter = "($ldapAttr=*)";
my $attr   = "$ldapAttr,objectClass";
my $scope  = "subtree";

  $cmd->{CommandText} = "<$base>;$filter;$attr;$scope";
  $cmd->{Properties}->{"Sort on"} = "cn";

my $rec = $cmd->Execute();
print $rec->{RecordCount} , " objecten\n";
my %classes;
until ($rec->{EOF}){
	my $class = $rec->Fields("objectClass")->{Value}->[-1];
	$classes{$class}++;

	$rec->MoveNext();
}

$rec->Close();
$con->Close();

#o and btw 
#canonicalName is een geconstrueerd attribuut en mag niet in de filter worden opgenomen.
foreach (in keys %classes){
	print $_ , "\n";
}

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