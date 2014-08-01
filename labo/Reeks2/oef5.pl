use strict;
use warnings;
use Cwd;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

my  $excel = Win32::OLE->GetActiveObject("Excel.Application") || Win32::OLE->new("Excel.Application", 'Quit');
my  $file = getcwd() . "/test.xlsx";
	$file =~ s/\//\\/g;
my  $book = $excel->{Workbooks}->Open($file);

foreach my $sheet ( in $book->{Worksheets} ){
	my $range = $sheet->Range("A1:D10")->{Value};
	print join("\t", @{$_}), "\n" foreach @{$range};

	   $range = $sheet->Cells(4,1);
    print $range->{Value}, "\n";
	
	   $range = $sheet->Range($sheet->Cells(1,1), $sheet->Cells(4,3));
    print join("\t", @{$_}), "\n" foreach @{$range};
}
