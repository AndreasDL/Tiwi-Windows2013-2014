#Eerste oplossing waarbij de lijst met (naam-waarde)-koppels niet geordend is.
use Win32::OLE 'in';

my %RootKey = ( HKEY_CLASSES_ROOT   => 0x80000000
              , HKEY_CURRENT_USER   => 0x80000001
              , HKEY_LOCAL_MACHINE  => 0x80000002
              , HKEY_USERS          => 0x80000003
              , HKEY_CURRENT_CONFIG => 0x80000005
              , HKEY_DYN_DATA       => 0x80000006 );

#verband tussen de numerieke waarde en de methode die moet worden uitgevoerd
my @GetValue = ( ""
               , "GetStringValue"
               , "GetExpandedStringValue"
               , "GetBinaryValue"
               , "GetDWORDValue"
               , ""
               , ""
               , "GetMultiStringValue" );

#geeft bovendien de naam van de returnwaarde die de value bevat
my @GetValueName = ( ""
               , "sValue"
               , "sValue"
               , "uValue"
               , "uValue"
               , ""
               , ""
               , "sValue" );

my $ComputerName = ".";
my $NameSpace = "root/cimV2";  #"root/default";  #kan ook gebruikt worden
my $Class = "StdRegProv";

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
my $Registry = $WbemServices->Get($Class);

# performantieverbetering: de verzameling van invoerparameters voor de functies EnumKey en EnumValues
# worden slechts 1 keer opgehaald, en de waarde van de invoerparameter hDefKey wordt  vooraf ingevuld.

#methode EnumKey(hDefKey,sSubKeyName);
my $EnumKeyInParameters=$Registry->{Methods_}->{EnumKey}->{InParameters};
#hDefKey is altijd hetzelfde
$EnumKeyInParameters->{Properties_}->Item(hDefKey)->{Value} = $RootKey{HKEY_LOCAL_MACHINE};

#methode EnumValues(hDefKey,sSubKeyName)
my $EnumValuesInParameters=$Registry->{Methods_}->{EnumValues}->{InParameters};
#hDefKey is altijd hetzelfde
$EnumValuesInParameters->{Properties_}->Item(hDefKey)->{Value} = $RootKey{HKEY_LOCAL_MACHINE};

$subtak="tcpip";
$start="SYSTEM\\Currentcontrolset\\Services\\$subtak";

print "$start";
ToonTak($start,"",0);

sub ToonTak{
    my ($Key,$PrintNaam,$Level)=@_;
    printf "\n\n%s%s\n",("\t" x $Level),$PrintNaam;

    #uitvoeren van methode EnumKey
    #sSubKeyName  installen
    $EnumKeyInParameters->{Properties_}->Item(sSubKeyName)->{Value} = $Key;
    my $EnumKeyOutParameters = $Registry->ExecMethod_(EnumKey,$EnumKeyInParameters);

    #uitvoeren van methode EnumValues
    #sSubKeyName instellen
    $EnumValuesInParameters->{Properties_}->Item(sSubKeyName)->{Value} =$Key;
    my $EnumValuesOutParameters = $Registry->ExecMethod_(EnumValues,$EnumValuesInParameters);

    #uitvoeren van de methode die de value kan ophalen. Dit is afhankelijk van het type!!
    $Names=$EnumValuesOutParameters->{sNames};
    $Types=$EnumValuesOutParameters->{Types};
    foreach my $i (0..$#{$Names}) {
        $methodeName=$GetValue[$Types->[$i]];
        $valueName=$GetValueName[$Types->[$i]];
        printf "\n\t%s= ",$Names->[$i];

        #methode om waarde op te roepen hangt af van het type
        my $MethodInParameters =$Registry->{Methods_}->{$methodeName}->{InParameters};
        $MethodInParameters->{Properties_}->Item(hDefKey)->{Value} = $RootKey{HKEY_LOCAL_MACHINE};
        $MethodInParameters->{Properties_}->Item(sSubKeyName)->{Value} = $Key;
        $MethodInParameters->{Properties_}->Item(sValueName)->{Value} = $Names->[$i];
        my $MethodOutParameters = $Registry->ExecMethod_($methodeName,$MethodInParameters);
        my $result=$MethodOutParameters->{$valueName};

        if ($Types[$i]==3) {  #omzetten naar juiste formaat
              map {printf "%02x ",$_} @{$result};
        }
        else {           #array of enkelvoudige waarde
            print ( ref $result ? join (" ",@{$result}) : $result);
        }
    }

    return if $EnumKeyOutParameters->{ReturnValue};
    foreach my $SubKey (sort {lc($b) cmp lc($b)} @{$EnumKeyOutParameters->{sNames}}) {
        ToonTak($Key."\\$SubKey",$SubKey,$Level+1) if $SubKey ne "";
    }
}
#Tweede oplossing waarbij de lijst met (naam-waarde)-koppels wel geordend is, 
#en die een performantie-verbetering oplevert omdat alle invoerParameters maar 1 keer worden aangemaakt.

use Win32::OLE 'in';

my %RootKey = ( HKEY_CLASSES_ROOT   => 0x80000000
              , HKEY_CURRENT_USER   => 0x80000001
              , HKEY_LOCAL_MACHINE  => 0x80000002
              , HKEY_USERS          => 0x80000003
              , HKEY_CURRENT_CONFIG => 0x80000005
              , HKEY_DYN_DATA       => 0x80000006 );

my @GetValue = ( ""
               , "GetStringValue"
               , "GetExpandedStringValue"
               , "GetBinaryValue"
               , "GetDWORDValue"
               , ""
               , ""
               , "GetMultiStringValue" );               

my $ComputerName = ".";
my $NameSpace = "root/cimV2";  #"root/default";  #kan ook gebruikt worden
my $Class = "StdRegProv";

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
my $Registry = $WbemServices->Get($Class);

my %InParameters=();

# performantieverbetering: eenmalige constructie van hashstructuur invoerparameters, voor elke methode 1 element
foreach my $Method (in $Registry->{Methods_}) {
   $InParameters{$Method->{Name}} = $Method->{InParameters};
   $InParameters{$Method->{Name}}->{Properties_}->Item(hDefKey)->{Value} = $RootKey{HKEY_LOCAL_MACHINE};
}

$subtak="tcpip";
$start="SYSTEM\\Currentcontrolset\\Services\\$subtak";

print "$start";
ToonTak($start,"",0);

sub ToonTak {
    my ($Key,$SubKey,$Level)=@_;
    printf "%s%s\n",("\t" x $Level),$SubKey;
    $Key = $Key ?  "$Key\\$SubKey" : $SubKey;

    #uitvoeren van methode EnumValues
    $InParameters{EnumValues}->{Properties_}->Item(sSubKeyName)->{Value} = $Key;
    my $EnumValuesOutParameters = $Registry->ExecMethod_(EnumValues,$InParameters{EnumValues});

    #uitvoeren van de methode die de value kan ophalen. Dit is afhankelijk van het type!!
    unless ($EnumValuesOutParameters->{ReturnValue}) {
      for my $i ( sort { lc($EnumValuesOutParameters->{sNames}->[$a])
                     cmp lc($EnumValuesOutParameters->{sNames}->[$b]) } 0..$#{$EnumValuesOutParameters->{sNames}} ) {
        printf "%s[%s]=",("\t" x ($Level+1)),($EnumValuesOutParameters->{sNames}->[$i]);
        my $Type=$EnumValuesOutParameters->{Types}->[$i];

        if ($GetValue[$Type]) {
            $InParameters{$GetValue[$Type]}->{Properties_}->Item(sSubKeyName)->{Value} = $Key;
            $InParameters{$GetValue[$Type]}->{Properties_}->Item(sValueName)->{Value}  = 
                                                     $EnumValuesOutParameters->{sNames}->[$i];
            my $GetValueOutParameters = $Registry->ExecMethod_($GetValue[$Type],$InParameters{$GetValue[$Type]});
            $valueName=($Type==3 || $Type==4 ? "uValue" : "sValue"); #twee mogelijkheden !!
            $result=$GetValueOutParameters->{$valueName} unless $GetValueOutParameters->{ReturnValue};

            if ($Type==3) {  #omzetten naar juiste formaat
              map {printf "%02x ",$_} @{$result};
            }
            else {           #array of enkelvoudige waarde
               print ( ref $result ? join (" ",@{$result}) : $result);
            }
        }
        else {
            print "<UNSUPPORTED TYPE $Type>";
        }
        print "\n";
      }
    }

    #uitvoeren van methode EnumKey
    $InParameters{EnumKey}->{Properties_}->Item(sSubKeyName)->{Value} = $Key;
    my $EnumKeyOutParameters = $Registry->ExecMethod_(EnumKey,$InParameters{EnumKey});

    return if $EnumKeyOutParameters->{ReturnValue};
    foreach my $SubKey (sort {lc($b) cmp lc($b)} @{$EnumKeyOutParameters->{sNames}}) {
        ToonTak($Key,$SubKey,$Level+1);
    }
}

