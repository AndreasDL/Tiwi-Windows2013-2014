use Win32::OLE qw(in);
use Win32::OLE::Const ".*Excel"; #versie-onafhankelijk

my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
    || Win32::OLE->new('Excel.Application', 'Quit');

use Cwd;

$excelAppl->{DisplayAlerts}=0;
$excelAppl->{Visible}=1;


$padnaam=getcwd()."/voud.xlsx"; #absolute padnaam
$padnaam=~s/\//\\/g;  #vervang / door \

$book=$excelAppl->{Workbooks}->Add();

$sheet=$book->WorkSheets(1);
$sheet->{name}="veelvouden van 2 tot 10" ;
#$range=$sheet->Range("A1:I50"); #beter vervangen door onderstaande regel
$range=$sheet->Range($sheet->Cells(1,1),$sheet->Cells(50,9)); 
$mat = $range->{Value};
$i=1;
foreach my $rij (@$mat) {
     $j=2;
     foreach (@$rij){
         $_=$i*$j if ($i*$j<=100);
         $j++;
     }
     $i++;
}
$range->{Value}=$mat; #Niet cel per cel wegschrijven

$range->Rows(1)->{font}->{bold}=1;


$range->Borders(xlInsideVertical)->{LineStyle} = xlContinuous;
$range->Borders(xlEdgeRight)->{LineStyle} = xlContinuous;
$range->Borders(xlEdgeLeft)->{LineStyle} = xlContinuous;
$range->rows(1)->Borders(xlEdgeBottom)->{LineStyle} = xlContinuous;
$book->SaveAs($padnaam);

#Andere oplossing voor de matrix-bewerkingen :
for ($i=1;$i<=100;$i++){
     for ($j=2; $i*$j <= 100; $j++) {
         $mat->[$i-1][$j-2]=$i*$j;
     }
}

