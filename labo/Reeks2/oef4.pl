use strict;
use warnings;
use Cwd;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

my  $excel = Win32::OLE->GetActiveObject("Excel.Application") || Win32::OLE->new("Excel.Application", 'Quit');


my  $file = getcwd() . "/" . "test.xlsx";
	$file =~ s/\//\\/g;
print $file;
my  $book = $excel->{Workbooks}->Open($file);

