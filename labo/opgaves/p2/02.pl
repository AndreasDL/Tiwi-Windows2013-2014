use Win32::OLE qw(in);

my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
    || Win32::OLE->new('Excel.Application', 'Quit');

#ophalen van argumenten
@ARGV or die "Geef een argument nl. de filenaam van het excel-bestand\n";

#toon de default directory van Excel
print "padnaam=",$excelAppl->{DefaultFilePath};

use Cwd;
$excelAppl->{DefaultFilePath} = getcwd(); #wijzig naar de werkdirectory
$padnaam=$ARGV[0];

#alternatief
$padnaam=getcwd()."/".$ARGV[0]; #absolute padnaam
$padnaam=~s/\//\\/g;  #vervang / door \


$book=$excelAppl->{Workbooks}->Open($padnaam);  #wordt nu gezocht in de werkdirectory

print "QueryObjectType = ", join(" / ",Win32::OLE->QueryObjectType($book)),"\n";
print "Last error= ",Win32::OLE->LastError(),"\n" ;
print  ref $book or die "bestand $padnaam kan niet geopend worden met excel\n";

print "\naantal werksheets: $book->{Worksheets}->{Count}\n";

