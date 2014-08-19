# implementatie bind_object functie: zie sectie 5

use Win32::OLE 'in';
use Win32::OLE::Variant;
use Win32::OLE::Const "Active DS Type Library";

@ARGV == 2 or die "geef twee argumenten :  usernaam Ldap-attribuut\n";    

$wie=$ARGV[0];

#serverless binding
my $RootObj = bind_object("RootDSE");

my $cont = bind_object("OU=EM7INF,OU=Studenten,OU=iii,".$RootObj->get(defaultNamingContext));
my $user=$cont->getObject("user","cn=$wie");

unless ($user) {
    $cont = bind_object("OU=Docenten,OU=iii,".$RootObj->get(defaultNamingContext));
    $user=$cont->getObject("user","cn=$wie");
}

unless($user ){
    die( "$wie niet gevonden\n");
}

$prop=$ARGV[1];

$k=isset($user,$prop);
defined($k) ||  die("$prop is niet ingesteld\n");

toon($user,$prop);      #regel(1)



sub isset{
   my ($user,$prop)=@_;
   $user->GetInfoEx([$prop],0);     #vraag expliciet om prop in de cache te plaatsen
   return (grep {lc($user->Item($_)->{Name}) eq lc($prop)} 0..$user->{PropertyCount}-1)[0];
}

sub toon {
    my ($user,$prop)=@_;

    my $attribuut = $user->Item($prop);
#   my $attribuut = $user->Next();
    my $prefix    = $prop . " (" . $attribuut->{ADsType} . ")";
    foreach my $waarde ( @{$attribuut->{Values}} )  {
        if ( $attribuut->{ADsType} == ADSTYPE_NT_SECURITY_DESCRIPTOR) {
             $sec_object=$propValue->GetObjectProperty($attribuut->{ADsType});
             $suffix = "eigenaar is ..." . $sec_object->{owner};
        }
        elsif ( $attribuut->{ADsType} == ADSTYPE_OCTET_STRING) {
             $inhoud=$waarde->GetObjectProperty($attribuut->{ADsType});
             $suffix = sprintf "%*v02X ","",$inhoud;
        }
        elsif ( $attribuut->{ADsType} == ADSTYPE_LARGE_INTEGER ) {
             $inhoud=$waarde->GetObjectProperty($attribuut->{ADsType});
             $suffix = convert_BigInt_string($inhoud->{HighPart},$inhoud->{LowPart});
        }
        else {
             $suffix = $waarde->GetObjectProperty($attribuut->{ADsType});
            }
        printlijn( \$prefix, $suffix );
   }
}

sub printlijn {
    my ( $refprefix, $suffix ) = @_;
    printf "%-35s%s\n", ${$refprefix}, $suffix;
    ${$refprefix} = "";
}


use Math::BigInt;
sub convert_BigInt_string{
    my ($high,$low)=@_;
    my $HighPart = Math::BigInt->new($high);
    my $LowPartb = Math::BigInt->new($low);
    my $Radix    = Math::BigInt->new('0x100000000'); #dit is 2^32
    $LowPart+=$Radix if ($LowPart<0); #als unsigned int interperteren

    return ($HighPart * $Radix + $LowPart);
}

