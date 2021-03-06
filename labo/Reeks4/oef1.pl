use strict;
use warnings;
use Win32::OLE::Const 'Microsoft WMI Scripting';
$Win32::OLE::Warn = 3;


my $namespace = "root/cimv2";
my $compname  = "localhost";

#locaal
#manier 1
my $wbem	  = Win32::OLE->GetObject("winmgmts://$compname/$namespace");
#manier 2
my $locator   = Win32::OLE->new("WbemScripting.SWbemLocator");
#my $wbem      = $locator->ConnectServer($compname,$namespace);

#remote
#my $wbem      = $locator->ConnectServer($compname,$namespace,"$compname\\administrator", <pass>);
print join(" / ",Win32::OLE->QueryObjectType($wbem)) , "\n";