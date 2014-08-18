use strict;
use warnings;
use Win32::OLE;
$Win32::OLE::Warn = 3;

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost","root/cimv2");

#manier 1
my $ass  = $wbem->AssociatorsOf("Win32_Directory",undef,undef,undef,undef,undef,1);
print $ass->{Count} , "\n";

#manier 2
my $hole = $wbem->Get("Win32_Directory");
   $ass  = $hole->Associators_(undef,undef,undef,undef,undef,1); 
print $ass->{Count} , "\n";