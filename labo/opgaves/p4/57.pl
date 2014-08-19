use Win32::OLE qw(EVENTS);

my $ComputerName  = ".";
my $Sink = Win32::OLE->new ('WBemScripting.SWbemSink');
Win32::OLE->WithEvents($Sink,\&EventCallBack);

my $NameSpace1 = "root/cimv2";
my $WbemServices1 = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace1");
my $Query1 = "SELECT * FROM __InstanceOperationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_Process'";
$WbemServices1->ExecNotificationQueryAsync($Sink, $Query1);

my $NameSpace2 = "root/msapps12";
my $WbemServices2 = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace2");
my $Query2 = "SELECT * FROM __InstanceCreationEvent WITHIN 5
     WHERE TargetInstance ISA 'Win32_ExcelWorkBook'
        or TargetInstance ISA 'Win32_Word12Document'
        or TargetInstance ISA 'Win32_PowerPointPresentation'
        or TargetInstance ISA 'Win32_AccessDataBase'";
$WbemServices2->ExecNotificationQueryAsync($Sink, $Query2);

use Win32::Console;
my $Console = Win32::Console->new(STD_INPUT_HANDLE);
until ($Console->GetEvents() && ($Console->Input())[1]) {
	Win32::OLE->SpinMessageLoop();
	Win32::Sleep(500);
}

$Sink->Cancel();
Win32::OLE->WithEvents($Sink); #geen afhandeling meer bij dit SinkObject

sub EventCallBack(){
    my ($Source,$EventName,$Event,$Context) = @_;
    return unless $EventName eq "OnObjectReady";
    my $className=$Event->{Path_}->{Class};
    return if  $className eq "__InstanceModificationEvent";
    
    if ($Event->{TargetInstance}->{Path_}->{Class} eq "Win32_Process") {
       printf "%-29s started\n", $Event->{TargetInstance}->{Name} if  $className eq "__InstanceCreationEvent";
       printf "%-29s stopped\n", $Event->{TargetInstance}->{Name} if  $className eq "__InstanceDeletionEvent";
    }
    else	{
       printf "%-29s %s\n", $Event->{TargetInstance}->{Path_}->{Class}, $Event->{TargetInstance}->{Path};
    }
}
