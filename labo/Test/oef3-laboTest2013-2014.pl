#3) breng overerving in kaart zoals te zien in overerving.txt 
#(dus gwn met extra indents per niveau).
#gebruik hiervoor een recursieve functie
use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $user = "";
my $pass = "";

sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->getObject((uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par);
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
my $con = Win32::OLE->CreateObject("ADODB.Connection");
   $con->{Provider} = "ADsDSOObject";
   $con->{Properties}->{"User ID"} = $user;
   $con->{Properties}->{"Password"} = $pass;
   $con->{Properties}->{"Encrypt Password"} = 1;#true
   $con->Open();
my $cmd = Win32::OLE->CreateObject("ADODB.Command");
   $cmd->{ActiveConnection} = $con;
   $cmd->{Properties}->{"Page Size"} = 20;

my $base    = "LDAP://";
   $base   .= "193.190.126.71/" unless(uc($ENV{USERDOMAIN}) eq "III");
   $base   .= $rootDSE->Get("schemaNamingContext");
my $filter  = "(&(objectCategory=classSchema))";
my $attr    = "adspath,ldapdisplayname";
my $scope   = "subtree";

   $cmd->{CommandText} = "<$base>;$filter;$attr;$scope";

#start at the top
my $top = "Top";
handle($top , " ");

#recursive
sub handle{
	my ($ldapdisplayname , $prefix ) = @_;
	print $prefix , $ldapdisplayname , "\n";
	
	#kinderen ophalen
	$filter = "(&(objectCategory=classSchema)(subClassOf=$ldapdisplayname))";
    $cmd->{CommandText} = "<$base>;$filter;$attr;$scope";
    my $res = $cmd->Execute();

	$prefix = "$prefix  ";
	until($res->{EOF}){
		
		my $l = $res->Fields("ldapdisplayname")->{Value};
		if( lc($l) ne lc($ldapdisplayname) ){ #don't do subclassof = class (top is subclassof top)
			#voor elk kind uitschrijven	
			handle($l,$prefix);
		} 
		$res->MoveNext();
	}
}