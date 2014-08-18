use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Variant;

my $DateTime = Win32::OLE->new("WbemScripting.SWbemDateTime"); #data manipuleren

my $WbemServices = Win32::OLE->GetObject("winmgmts://localhost/root/cimv2");

#Basisquery :
#$Query="Select * from Win32_NTLogEvent  Where   ( EventCode = '6005' or EventCode = '6006' )";

#query uitbreiden met extra informatie :
my $Query="Select * from Win32_NTLogEvent  Where Logfile = 'System'
                                       and ( EventCode = '6005' or EventCode = '6006' )
                                       and SourceName = 'EventLog'";

my $Instances = $WbemServices->ExecQuery($Query);
my $StartupTime;
foreach my $Instance (sort {$a->{TimeWritten} cmp $b->{TimeWritten}} in $Instances) {
    $DateTime->{Value} = $Instance->{TimeWritten};
    my $periode=($DateTime->GetFileTime - $StartupTime)/10000000;
    printf "%-22s: %s %s\n",$DateTime->GetVarDate, $Instance->{Message} =~ /(started|stopped)/
                ,($Instance->{EventCode} == 6006 && $StartupTime ? "na $periode s" : "");
    $StartupTime=($Instance->{EventCode} == 6005 ? $DateTime->GetFileTime : undef);
}
