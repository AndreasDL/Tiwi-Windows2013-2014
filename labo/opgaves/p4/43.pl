
use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $WbemServices =  Win32::OLE->GetObject("winmgmts://$ComputerName/root/cimv2");
my $Classes = $WbemServices->SubclassesOf("",wbemFlagUseAmendedQualifiers);

foreach my $Class ( in $Classes) {
  my @Privileges = ();
  foreach my $Method (in $Class->{Methods_}) {
    my $Privileges = $Method->{Qualifiers_}->Item(Privileges);
    if ($Privileges && $Privileges->{Value}) {
	push @Privileges,
                ($Method->{Name} . " {(" . (join ",",(map {/Se(.*)Privilege/} @{$Privileges->{Value}})) . ")}!");
      }
  }
  printf ("\n%-33s:\n\t%s\n", $Class->{Path_}->{RelPath}, (join "\n\t",@Privileges)) if @Privileges;
}


