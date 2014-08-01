use strict;
use warnings;
use Cwd;
use Win32::OLE qw(in);
use Win32::OLE::Const 'Microsoft Excel';
$Win32::OLE::Warn = 3;

my  $excel = Win32::OLE->GetActiveObject("Excel.Application") || Win32::OLE->new("Excel.Application");
	$excel->{DisplayAlerts} = 0;
    $excel->{Visible} = 1;
my  $file  = getcwd() . "/voud.xlsx";
	$file  =~ s/\//\\/g;
my  $book  = $excel->{Workbooks}->Add();
my  $sheet = $book->Worksheets(1);
	$sheet->{Name} = "execise";
my  $range = $sheet->Range($sheet->Cells(1,1) , $sheet->Cells(50,9));

#Creating output;
my  @mat;
for ( my $i=1 ; $i <= 100 ; $i++ ){
     for ( my $j = 2 ; $i*$j <= 100 ; $j++ ) {
         $mat[$i-1][$j-2] = $i * $j;
     }
}
$range->{Value} = \@mat;

#layout
$range->Rows(1)->{font}->{bold} = 1;
$range->Borders(xlInsideVertical)->{LineStyle} = xlContinuous;
$range->Borders(xlEdgeRight)->{LineStyle} = xlContinuous;
$range->Borders(xlEdgeLeft)->{LineStyle} = xlContinuous;
$range->rows(1)->Borders(xlEdgeBottom)->{LineStyle} = xlContinuous;
$book->SaveAs($file);