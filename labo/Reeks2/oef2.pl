use strict;
use warnings;
use Win32::OLE qw(in);
use Cwd;
$Win32::OLE::Warn = 3;

my  $excel = Win32::OLE->GetActiveObject('Excel.Application') || Win32::OLE->new('Excel.Application', 'Quit');

my  $file = "test.xlsx";
my  $path = getcwd() . "/" . $file;
	$path =~ s/\//\\/g; #replace / with  \

print $path , " opened\n";
my  $book = $excel->{Workbooks}->Open($path);

print "QueryObjectType = ", join(" / ",Win32::OLE->QueryObjectType($book)),"\n";
print "Last error= ",Win32::OLE->LastError(),"\n" ;
print  ref $book or die "bestand $path kan niet geopend worden met excel\n";

print "\naantal werksheets: $book->{Worksheets}->{Count}\n";