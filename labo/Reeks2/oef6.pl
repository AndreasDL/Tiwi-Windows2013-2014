use strict;
use warnings;
use Cwd;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

my  $excel = Win32::OLE->GetActiveObject("Excel.Application") || Win32::OLE->new("excel.application", 'Quit');
my  $file  = getcwd() . "/test.xlsx";
	$file  =~ s/\//\\/g;
my  $book  = $excel->{Workbooks}->Open($file);
my  $sheet = $book->{Worksheets}->Item(1);

#gen input;
my @mat;
for (my $i = 0 ; $i < 5 ; $i++){
	for (my $j = 0; $j < 2 ; $j++){
		$mat[$i][$j] = "hoi";
	}
}

$sheet->Range("A1:B5")->{Value} = \@mat;
$book->Save();

my $range = $sheet->{UsedRange};
my $mat   = $range->{Value};
if (ref $mat){#ref => array
	print "Worksheet: ", $sheet->{Name}, " of workbook: ", $book->{Name}, " : " ,
		  "$range->{rows}->{count} op $range->{columns}->{count}\n";
	print join ("  \t" , @{$_}) , "\n" foreach @{$mat};
}else{
	print "Worksheet: ", $sheet->{Name}, " of workbook: ", $book->{Name}, " is empty!\n";
}