#zie hiervoor om $book te initialiseren.

#een waarde wijzigen
$nsheet=$book->{Worksheets}->Item(1);
$range=$nsheet->Cells(4,1);
$range->{Value}=20;

for ($i=0;$i<4;$i++){
     for ($j=0; $j < 3; $j++) {
         $mat->[$i][$j]="***";  #zero-based in perl
     }
}
#Value van de juiste range wijzigen
$nsheet->Range($nsheet->Cells(1,1),$nsheet->Cells(4,3))->{Value}=$mat;
$book->Save();

