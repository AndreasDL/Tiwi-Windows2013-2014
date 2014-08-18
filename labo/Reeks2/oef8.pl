use strict;
use warnings;
use Cwd;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

#open stuffs
my  $excel = Win32::OLE->GetActiveObject("Excel.Application") || Win32::OLE->new("Excel.Application", 'Quit');
	$excel->{Visible} = 1;
	$excel->{DisplayAlerts} = 0;
my  $file1 = getcwd()  . "/punten.xls";
	$file1 =~ s/ \//\\/g;
my  $book1 = $excel->{Workbooks}->Open($file1);
my  $file2 = getcwd() . "/punten2.xls";
	$file2 =~ s/\//\\/g;
my  $book2 = $excel->{Workbooks}->Open($file2);

#put punten2 in map
my  %map;
my  $arr = $book2->Worksheets(1)->{UsedRange}->{Value};
foreach my $arrRef (@$arr){
	my ($n,$p) = @{$arrRef}[0,1];
	$map{$n} = $p;
}

#add punten2 to punten
my  $orig = $book1->Worksheets(1)->{UsedRange}->{Value};
foreach my $row (@$orig){
	${$row}[2] = $map{${$row}[0]};

	${$row}[3] = int ( (${$row}[1] + ${$row}[2] + 1) / 2 ); #+1 for ceil
}

$book1->Worksheets(1)->Range("A1:D" . @$orig)->{'Value'} = $orig;
$book1->save();

#layout = bs
$book1->Close();
$book2->Close();