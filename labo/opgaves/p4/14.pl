use Win32::OLE 'in';
use Win32::OLE::Variant;

my $ComputerName = "Localhost";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WBemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $DateTime = Win32::OLE->new("WBemScripting.SWbemDateTime");
my $ClassName="Win32_OperatingSystem";

#foute oplossing :
#my $Class=$WBemServices->get($ClassName); #levert de klasse, en niet het WMI object zelf 
                                           #dat overeenkomt met het Operating System

#juiste aanpak
my $instance=$WBemServices->get("$ClassName=@"); #unieke instantie van een singletonklasse
#alternatief om de unieke instantie op te halen
my $instances = $WBemServices->InstancesOf($ClassName);
print $instances->{Count} , " exempla(a)r(en) \n"; #er zal maar 1 exemplaar zijn

#Het unieke element ophalen met :
my ($instance)=in $instances; 

print $ClassName, " bevat ", $instance->{Properties_}->{Count}," properties en ", 
                             $instance->{SystemProperties_}->{Count}," systemproperties : \n\n";

foreach my $prop (in $instance->{Properties_}, $instance->{SystemProperties_}){

  if ($prop->{CIMType} == 101){ #datum
       $DateTime->{Value} = $prop->{Value};     
       printf "%-42s : %s \n",$prop->{Name},$DateTime->GetVarDate;
  }
  else {
      printf "%-42s : %s %s \n",$prop->{Name},
             ($prop->{Isarray} ? "(ARRAY)" : "",
             ($prop->{Isarray} ? join ",",@{$prop->{Value}} : $prop->{Value}));
  }
}


