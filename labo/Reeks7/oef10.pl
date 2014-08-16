use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;


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
   $base  .= $rootDSE->Get("configurationNamingContext");
my $filter = "(fromServer=*)";
my $attr   = "*"; #adspath only ?
my $scope  = "subtree";

  $cmd->{CommandText} = "<$base>;$filter;$attr;$scope";
  $cmd->{Properties}->{"Sort on"} = "cn";

my $rec = $cmd->Execute();
print $rec->{RecordCount} , " objecten\n";

$rec->Close();
$con->Close();

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