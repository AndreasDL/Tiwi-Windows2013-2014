use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = "LocalHost";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my @Classes = @ARGV ? map {$WbemServices->Get($_,wbemFlagUseAmendedQualifiers)} @ARGV  
                    : in $WbemServices->SubclassesOf("",wbemFlagUseAmendedQualifiers);

foreach my $Class (@Classes) {
    my $Methods = $Class->{Methods_};
    next unless $Methods->{Count};

    printf "\n%s bevat %d methodes met volgende aanroep (en extra return-waarde):\n ", 
                $Class->{Path_}->{Class},$Methods->{Count};
    foreach my $Method (sort {uc($a->{Name}) cmp uc($b->{Name})} in $Methods) {
         printf "\n\t%s " ,$Method->{Name};
         printf "( %s )",join(",",map  {$_->{Qualifiers_}->{Optional} ? "[$_->{Name}]" : $_->{Name}}
                                  sort { $a->Qualifiers_(ID)->{Value} <=> $b->Qualifiers_(ID)->{Value} }
                                  in $Method->{InParameters}->{Properties_} )
                if $Method->{InParameters};

         printf "\n\t\tout:\t%s" ,
                    join(",",map {$_->{Name}.( $_->Qualifiers_(ID) ? "(" . $_->Qualifiers_(ID)->{Value} . ")" : "" ) }
                         in $Method->{OutParameters}->{Properties_} )
                if $Method->{OutParameters} && $Method->{OutParameters}->{Properties_}->{Count} > 1; #extra out-parameter naast ReturnValue
         printf "\n\t  -> is statische methode" if $Method->{Qualifiers_}->{static};   
    };
    print "\n------------------------------------------------------------";
}