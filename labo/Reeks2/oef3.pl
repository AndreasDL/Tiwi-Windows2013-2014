use strict;
use warnings;
use Win32::OLE qw(in);
use Cwd;
$Win32::OLE::Warn = 3;

my  $excel = Win32::OLE->GetActiveObject('Excel.Application') || Win32::OLE->new('Excel.Application', 'Quit');

my  $file = "test.xlsx";
my  $path = getcwd() . "/" . $file;
	$path =~ s/\//\\/g; #replace / with  \

my  $book = $excel->{Workbooks}->Open($path);

print "\naantal worksheets: $book->{Worksheets}->{Count}\n";
foreach my $sheet (in $book->{Worksheets}){
	print "Sheet name : ", $sheet->{Name} , 
		  "\n\tused range = ", $sheet->{UsedRange}->{columns}->{count} , " : ",
		  				   $sheet->{UsedRange}->{rows}->{count}, "\n";
}