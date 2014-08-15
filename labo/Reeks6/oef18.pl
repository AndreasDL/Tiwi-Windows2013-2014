use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

sub bind_object{
    my $par = shift;
    if (uc($ENV{USERDOMAIN}) eq "III"){
        return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par );
    }else{
        return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
            (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") .$par,
            "",
            "",
            1
        );
    }
}

my $RootObj = bind_object("RootDSE");
$RootObj->{DnsHostName}; #initialiseren van Property Cache

my @containers=qw(defaultNamingContext configurationNamingContext schemaNamingContext);

my @ARGV = 0..2 unless @ARGV;
foreach my $nr (@ARGV) {
    bepaal_klassen($RootObj->{$containers[$nr]});
}

#OF
#@containers=@{$RootObj->{"namingContexts"}}; #bevat 5 elementen
#@ARGV = 0..4 unless @ARGV; #er zijn 5 elementen
#foreach $nr (@ARGV) {
#    bepaal_klassen($containers[$nr]);
#}


my %classes;

sub bepaal_klassen {
    my $contname=shift;
    print "\n zoek in : ",$contname;
    print "\nEven geduld !!! \n";
    my $obj=bind_object($contname);
    $classes{$obj->{class}}=1;
    zoek($obj);
    my $n = scalar(keys %classes);
    print "\n$n verschillende klassen in $contname\n";
    print_geordend();
    %classes=();   #hash opkuisen
}

sub zoek {
    my $cont=shift;
    foreach my $obj (in $cont) {
        $classes{$obj->{class}}++;
        print "\n",$obj->{class} if $classes{$obj->{class}}%100==99;
        zoek ($obj);    #recursief
    }
}

sub print_geordend {
    printf "\n%-20s : %s",$_,$classes{$_}
        foreach sort { $classes{$b}<=> $classes{$a} } keys %classes;
}