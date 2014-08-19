#maakt voor elke methode van een klasse een overzicht aan in excel
#geeft hierbij alle invoerParameters weer naast de klassenaam
use strict;
use warnings;
use Cwd;
use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting';
use Data::Dumper;
#$Win32::OLE::Warn = 3;

my $className = "Win32_Directory";
my $xlsPath = getcwd() . "/test.xlsx";
   $xlsPath =~ s/\//\\/g;

#omzetten van colDim naar een letter (voor worksheet in excel)
my  @DIMS = qw("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z");

#deel1, methode ophalen
my $loc  = Win32::OLE->new("WbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("LocalHost","root/cimv2");
my $class = $wbem->Get($className,wbemFlagUseAmendedQualifiers);

my @methods;
my $colCount = 0; #keep the highest colcount (needed for the range in excel)
my $rowCount = 0;
foreach my $method (in $class->{Methods_}){
   print "Method: ", $method->{Name} , "\n";
   next unless $method->{InParameters};

   my @line;
   push @line , $method->{Name};

   foreach( sort{ uc($a->{Name}) cmp uc($b->{Name}) } in $method->{InParameters}->{Properties_} ){
      printf "\tParam: %-30s %s\n" , $_->{Name} , ($_->{Qualifiers_}->{Optional} ? " - optional" : ""); #doordat we hier optional aanroepen zonder te kijken of het bestaat krijgen we soms lelijke excepties in uitvoer => niet erg
      push @line , $_->{Name};
   }

   #keep highest colcould
   $colCount < scalar @line ? $colCount = scalar @line : 1;

   #save in methods
   $methods[$rowCount] = \@line;
   $rowCount++;
}
$colCount--; #nodig anders 1 te veel
print "rows:" , $rowCount , " Cols: " , $colCount , "\n";


my $xls = Win32::OLE->GetActiveObject("Excel.Application") || Win32::OLE->new("Excel.Application" , "Quit");
   $xls->{Visible} = 1; #hide (already by default but still)
   $xls->{DisplayAlerts} = 0; #no we don't want annoying alerts

my $book  = $xls->Workbooks->Add();
my $sheet = $book->Worksheets(1);

   $sheet->Range("A1:" . $DIMS[$colCount] . $rowCount)->{'Value'} = \@methods;
   $book->SaveAs($xlsPath);
   $xls->Close();

print "should be at " , $xlsPath , "\n";