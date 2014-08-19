use Win32::OLE 'in';

my $ComputerName = "Localhost";
my $NameSpace = "root/cimv2";
#my $ClassName = $ARGV[0]; 
my $ClassName = "Win32_SubDirectory";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $Class=$WbemServices->Get($ClassName);
print $ClassName, " bevat ", $Class->{Properties_}->{Count}," properties en ", 
                             $Class->{SystemProperties_}->{Count}," systemproperties : \n\n";

foreach my $prop (in $Class->{Properties_}, $Class->{SystemProperties_}){
       print "\t",$prop->{Name}," (",$prop->{CIMType}, ($prop->{Isarray} ? " - is array" : ""),")\n";
}

