use Win32::OLE 'in';

my %RootKey = ( HKEY_CLASSES_ROOT   => 0x80000000
              , HKEY_CURRENT_USER   => 0x80000001
              , HKEY_LOCAL_MACHINE  => 0x80000002
              , HKEY_USERS          => 0x80000003
              , HKEY_CURRENT_CONFIG => 0x80000005
              , HKEY_DYN_DATA       => 0x80000006 );

my $ComputerName = ".";
my $NameSpace = "root/cimV2";  #"root/default";  #kan ook gebruikt worden
my $Class = "StdRegProv";

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
my $Registry = $WbemServices->Get($Class);  #statische methodes worden opgeroepen op de klasse

# performantieverbetering: de verzameling van invoerparameters voor de functie EnumKey wordt slechts 1 keer opgehaald,
# en de waarde van de invoerparameter hDefKey wordt  vooraf ingevuld.

my $InParameters=$Registry->{Methods_}->{EnumKey}->{InParameters};
$InParameters->{Properties_}->Item(hDefKey)->{Value} = $RootKey{HKEY_LOCAL_MACHINE};

#kies starttak
$start="SYSTEM\\Currentcontrolset\\Services\\tcpip";  #Hangt af van de keuze hiervoor

print "$start";
ToonTak($start,"",0);

sub ToonTak{
    my ($Key,$PrintNaam,$Level)=@_;
    printf "%s%s\n",("\t" x $Level),$PrintNaam;

    $InParameters->{Properties_}->Item(sSubKeyName)->{Value} = $Key;
    my $EnumKeyOutParameters = $Registry->ExecMethod_(EnumKey,$InParameters);

    return if $EnumKeyOutParameters->{ReturnValue};
    foreach my $SubKey (sort {lc($b) cmp lc($b)} @{$EnumKeyOutParameters->{sNames}}) {
        ToonTak($Key."\\$SubKey",$SubKey,$Level+1) if $SubKey ne "";
    }
}

