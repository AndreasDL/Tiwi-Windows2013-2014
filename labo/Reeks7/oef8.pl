use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Variant;
$Win32::OLE::Warn = 3;

my $user = "";
my $pass = "";
my $postCode = "9000"; #3071 zal niet veel opleveren :'(

my $rootDSE = bindObj("rootDSE");

my $con   = Win32::OLE->CreateObject("ADODB.Connection");
   $con->{Provider} = "ADsDSOObject";
   $con->{Properties}->{"User ID"} = $user;
   $con->{Properties}->{"Password"} = $pass;
   $con->{Properties}->{"Encrypt Password"} = 1; #true
   $con->Open();
my $cmd   = Win32::OLE->CreateObject("ADODB.Command");
   $cmd->{ActiveConnection} = $con;
   $cmd->{Properties}->{"Page Size"} = 20;

#fouten? ja => stoppen
Win32::OLE->LastError() && die (Win32::OLE->LastError());

my $base   = "LDAP://";
   $base  .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");
   $base  .= "OU=studenten,OU=iii," . $rootDSE->Get("defaultNamingContext");
my $filter = "(&(objectCategory=person)(objectClass=user)(postalCode=$postCode))";
my $attr   = "cn,streetAddress,l";
my $scope  = "subtree";

   $cmd->{CommandText} = "<$base>;$filter;$attr;$scope";
   $cmd->{Properties}->{"Sort On"} = "l";



my $rec   = $cmd->Execute();
print "Found " , $rec->{RecordCount} , " studenten\n";
until ( $rec->{EOF} ){
	printf "%-25s %s %s\n",
		$rec->Fields("cn")->{Value}, 
		$rec->Fields("streetaddress")->{Value},
		$rec->Fields("l")->{Value};
	$rec->MoveNext();
}

$rec->Close();
$con->Close();

sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par);
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			$user,
			$pass,
			1
		);
	}
}