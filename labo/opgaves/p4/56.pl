#melden dat een willekeurig proces opgestart of beeindigd wordt:

use Win32::OLE 'in';

my $ComputerName  = ".";
my $NameSpace = "root/cimv2";
my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");


my $query  =  "SELECT * FROM __InstanceOperationEvent WITHIN 1
               WHERE TargetInstance ISA 'Win32_Process'";

my $EventSource = $WbemServices->ExecNotificationQuery($query);

while (1) {
	my $Event = $EventSource->NextEvent();
        my $className=$Event->{Path_}->{Class};

	next if  $className eq "__InstanceModificationEvent";
	printf "%-29s started\n", $Event->{TargetInstance}->{Name} if  $className eq "__InstanceCreationEvent";
	printf "%-29s stopped\n", $Event->{TargetInstance}->{Name} if  $className eq "__InstanceDeletionEvent";
}

#zonder interne polling - met extrinsic Event wordt dit :
my $query  =  "SELECT * FROM Win32_ProcessTrace";

my $EventSource = $WbemServices->ExecNotificationQuery($query);

while (1) {
	my $Event = $EventSource->NextEvent();
        my $className=$Event->{Path_}->{Class};

        printf "%-29s started\n", $Event->{ProcessName} if  $className eq "Win32_ProcessStartTrace";
	printf "%-29s stopped\n", $Event->{ProcessName} if  $className eq "Win32_ProcessStopTrace";
}



#melden dat een Office document geopend wordt:
use Win32::OLE 'in';

my $ComputerName  = ".";
my $NameSpace = "root/msapps12";
my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");

my $EventSource = $WbemServices->ExecNotificationQuery(
    "SELECT * FROM __InstanceCreationEvent WITHIN 5
     WHERE TargetInstance ISA 'Win32_ExcelWorkBook'
        or TargetInstance ISA 'Win32_Word12Document'
        or TargetInstance ISA 'Win32_PowerPointPresentation'
        or TargetInstance ISA 'Win32_AccessDataBase'");

while (1) {
	my $Event = $EventSource->NextEvent();
	printf "%-29s %s\n", $Event->{TargetInstance}->{Path_}->{Class}, $Event->{TargetInstance}->{Path};
}

