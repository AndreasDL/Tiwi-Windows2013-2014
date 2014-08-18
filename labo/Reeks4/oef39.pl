use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting';
$Win32::OLE::Warn = 3;

my $processName = "notepad.exe";

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost","root/cimv2");

my $methods = $wbem->Get("Win32_Process",wbemFlagUseAmendedQualifiers)->{Methods_};

my %terminVals = createVals($methods->Item("Terminate"));

#directe methode
#foreach (in $wbem->ExecQuery("Select * From Win32_Process where Name = '$processName'")){
#	my $retVal = $_->Terminate();
#	print $_->{Handle} ,":", $terminVals{$retVal} , "\n";
#}

#formele methode
foreach (in $wbem->ExecQuery("Select * From Win32_Process where Name = '$processName'")){
	my $inVals  = $methods->{"Terminate"}->{InParameters};#in dit geval moeten ze niet ingevuld worden
	my $outVals = $_->ExecMethod_("Terminate",$inVals);
	my $retVal  = $outVals->{ReturnValue};

	print $_->{Handle} ,":", $terminVals{$retVal} , "\n";
}


sub createVals{
	my $method = shift;
	my %hash = ();
	@hash{@{$method->Qualifiers_("ValueMap")->{Value}}}
		 =@{$method->Qualifiers_("Values")->{Value}};
	return %hash;
}