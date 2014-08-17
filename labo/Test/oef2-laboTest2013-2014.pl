#2) schrijf een geneste LDAP query waarbij je de hulpklassen ophaalt 
#en alle klassen die gebruik maken van die hulpklasse. 
#Geef hierbij de uitvoer weer als in hulpklassen.txt
use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $user = "";
my $pass = "";

sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par );
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			$user,
			$pass,
			1
		);
	}
}

my $rootDSE = bindObj("rootDSE");
#connection
my $con = Win32::OLE->CreateObject("ADODB.Connection");
   $con->{Provider} = "ADsDSOObject";
   $con->{Properties}->{"User ID"} = $user;
   $con->{Properties}->{"Password"} = $pass;
   $con->{Properties}->{"Encrypt Password"} = 1;#true
   $con->Open();
#command
my $cmd = Win32::OLE->CreateObject("ADODB.Command");
   $cmd->{ActiveConnection} = $con;
   $cmd->{Properties}->{"Page Size"} = 20;

#query
my $base   = "LDAP://";
   $base  .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");
   $base  .= $rootDSE->Get("schemaNamingContext");
my $filter = "(&(objectCategory=classSchema)(objectClassCategory=3))";
my $attr   = "adspath,cn"; #enkel adspath dus
my $scope  = "subtree";

   $cmd->{CommandText} = "<$base>;$filter;$attr;$scope";
#recordset
my $rec = $cmd->Execute();

print "found " , $rec->{RecordCount} , " objects!\n";
#voor elke hulpklassen de klassen die hem gerbuiken ophalen
until ($rec->{EOF}){
	my $auxClass = $rec->Fields("cn")->{Value};
	print $auxClass , "\n";

	#filter
	my $ffilter .="(&(objectCategory=classSchema)(|(auxiliaryClass=$auxClass)(systemAuxiliaryClass=$auxClass)))";
	#output is not complete, since the systemAuxiliaryClass didn't work for some unknow reason. If you ever find it contact me @andreasCFDL Thanks!
       $cmd->{CommandText} = "<$base>;$ffilter;$attr;$scope";
    my $classes = $cmd->Execute();
    until($classes->{EOF}){
    	print "\t", $classes->Fields("cn")->{Value},"\n";
    	$classes->MoveNext();
    }

    $rec->MoveNext();
}	


#cleanup
$rec->Close();
$con->Close();