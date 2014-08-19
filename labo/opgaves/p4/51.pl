use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName  = ".";
my $NameSpace = "root/cimv2";
my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");

my $Instance = $WbemServices->Get(__EventFilter)->SpawnInstance_();
$Instance->{Name}           = 'test';
$Instance->{QueryLanguage}  = 'WQL';

#Met Excentric event
$Instance->{Query} = qq[SELECT * FROM Win32_VolumeChangeEvent  WHERE EventType = 2 and DriveName <> 'B:' ];
#Met interne polling
$Instance->{Query} = qq[SELECT * FROM __InstanceCreationEvent WITHIN 1  
                           WHERE TargetInstance ISA 'Win32_LogicalDisk' 
                           and TargetInstance.Name<>'B:' 
                           and TargetInstance.Name<>'A:' ];

$Filter   = $Instance->Put_(wbemFlagUseAmendedQualifiers);
$Filterpad = $Filter->{path};

my $Instance = $WbemServices->Get(ActiveScriptEventConsumer)->SpawnInstance_();
$Instance->{Name}             = "test";
$Instance->{ScriptingEngine}  = "PerlScript";
$Instance->{ScriptText}       = q[open FILE, ">>C:\\\\usb.txt";print FILE "USB ingeplugd\n"; ]; 
$Consumer  = $Instance->Put_(wbemFlagUseAmendedQualifiers);
$Consumerpad = $Consumer->{path};


my $Instance = $WbemServices->Get(__FilterToConsumerBinding)->SpawnInstance_();
$Instance->{Filter}   = $Filterpad;
$Instance->{Consumer} = $Consumerpad;
$Result = $Instance->Put_(wbemFlagUseAmendedQualifiers);
print Win32::OLE->LastError(),"\n";
print $Result->{path};


