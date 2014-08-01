use strict;
use warnings;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

#start excel embedded if needed; otherwise use the existing
my  $excel = Win32::OLE->GetActiveObject('Excel.Application') || Win32::OLE->new('Excel.Application', 'Quit');
	$excel->{visible} = 1;

#how many are open? should be empty
print "\nworkbook count ", $excel->{Workbooks}->{Count};

my  $book = $excel->{Workbooks}->Add();
	$book->{Worksheets}->add();
print "\nworkbook count After ", $excel->{Workbooks}->{Count};
print "\n\tSheets in workbook ", $book->{Worksheets}->{Count}, " : " ;
print "\n\t\t$_->{Name}" foreach in $book->{Worksheets};

	$excel->{DisplayAlerts} = 0;#avoid error msg when closing b/c the workbook isn't saved;