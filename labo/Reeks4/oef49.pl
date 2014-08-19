use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting';
$Win32::OLE::Warn = 3;

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost","root/cimv2");

#oorzaak event = opstarten van notepad of calc
#aanmaken eventFilter
my $eventFilter = $wbem->Get("__EventFilter")->SpawnInstance_();
   $eventFilter->{Name} = "VoorPrulScript";
   $eventFilter->{QueryLanguage} = "WQL";
   $eventFilter->{Query} = "select * from __InstanceCreationEvent 
		within 10
		where TargetInstance ISA 'Win32_Process' 
			and (TargetInstance.Name = 'calc.exe'
				or TargetInstance.Name = 'notepad.exe'
			)";
my $filter = $eventFilter->Put_(wbemFlagUseAmendedQualifiers);

#event1 : afsluiten van het process
my $closer = $wbem->Get("CommandLineEventConsumer")->SpawnInstance_();
   $closer->{Name} = "closerPrulScript";
   $closer->{CommandLineTemplate} = "c:\\WINDOWS\\system32\\taskkill.exe /f /pid %TargetInstance.ProcessID%";
my $closeConsumer = $closer->Put_(wbemFlagUseAmendedQualifiers);

#event2 : mail => skip werkt toch niet


#koppelingen
my $koppeling = $wbem->Get("__FilterToConsumerBinding")->SpawnInstance_();
   $koppeling->{Filter}   = $filter->{path};
   $koppeling->{Consumer} = $closeConsumer->{path};
my $result = koppeling->Put_(wbemFlagUseAmendedQualifiers);
#2e koppeling maken voor 2e reactie