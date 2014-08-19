use Win32::OLE 'in';

my $ComputerName = '.';
my $Privileges="{(Debug)}!";
my $WbemServices = Win32::OLE->GetObject("winmgmts:$Privileges//$ComputerName/root/cimv2");
my $ProcessName = "notepad.exe";

$_->Terminate foreach in $WbemServices->ExecQuery("Select * From Win32_Process Where Name='$ProcessName'");


