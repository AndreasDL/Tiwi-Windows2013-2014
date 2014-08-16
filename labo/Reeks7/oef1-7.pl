use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Variant;
$Win32::OLE::Warn = 3;

#connection & command stuff
my $rootDSE = bindObj("rootDSE");

#connection object voor de verbinding
my $con = Win32::OLE->CreateObject("ADODB.Connection");
   $con->{Provider} = "ADsDSOObject";
   $con->{Properties}->{"User ID"}  = "";
   $con->{Properties}->{"Password"} = "";
   $con->{Properties}->{"Encrypt Password"} = 1;
   $con->Open();


#command object voor het commando
my $cmd = Win32::OLE->CreateObject("ADODB.Command");
   $cmd->{ActiveConnection} = $con;
   $cmd->{Properties}->{"Page Size"} = 20; #nodig anders worden resultaten gelimiteerd

#fouten? ja => stoppen
Win32::OLE->LastError() && die (Win32::OLE->LastError());

#query stuff
#base
my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");        # als je niet in het domein zelf zit
   $sBase .= $rootDSE->Get("defaultNamingContext");#"DC=iii,DC=hogent,DC=be";
#filter
my $sFilter     = "(&(objectCategory=printQueue)(printColor=TRUE)(printDuplexSupported=TRUE))";
#attributes
my $sAttributes = "printerName,printRate,printMaxResolutionSupported,printStaplingSupported";
#scope
my $sScope      = "subtree";
#integreren in commando object
   $cmd->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $cmd->{Properties}->{"Sort On"} = "printerName";


#exec & iterate results
my $rec = $cmd->Execute();
Win32::OLE::LastError() && die (Win32::OLE->LastError()); #fouten? ja => stoppen
print $rec->{RecordCount} , " Objects found!\n";

#print $rec->{Fields}->{Count} , " LDAP attributen opgehaald per AD-object\n";
#foreach my $field (in $rec->{Fields}){
#	print "\n$field->{name}($field->{type}):";
#	my $waarde = $field->{value};
#	foreach (ref $waarde eq "ARRAY" ? @{$waarde} : $waarde){
#		$field->{type} == 204 ? printf "\n\t%*v02X ","", $_ : print "\n\t$_";
#	}
#}

my $x = 0;
until ($rec->{EOF}){
	$x++;
	print "Printer $x " , $rec->Fields("printerName")->{Value} , ":\n",
		"\tStapling supported: ", $rec->Fields("printStaplingSupported")->{Value} , "\n",
		"\tPrintrate:          ", $rec->Fields("printRate")->{Value}, "\n",
		"\tMax resolution:     ", $rec->Fields("printMaxResolutionSupported")->{value},  "\n",;
	$rec->MoveNext();
}

$rec->Close();
$con->Close();


sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III"){
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