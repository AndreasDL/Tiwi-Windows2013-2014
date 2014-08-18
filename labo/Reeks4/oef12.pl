use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $className = "Win32_SubDirectory";

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost","root/cimv2");

my $class = $wbem->Get($className);
print "De klasse " , $className , " bevat " , $class->{SystemProperties_}->{Count} , " systemProperties!\n";
print"\t$_\n" foreach (map{$_->{Name}} in $class->{SystemProperties_});
print "En " , $class->{Properties_}->{Count} , " properties!\n";
print"\t$_\n" foreach (map{$_->{Name}} in $class->{Properties_});

