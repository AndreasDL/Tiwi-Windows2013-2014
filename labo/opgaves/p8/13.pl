#. . . implementatie functie bind_object zie sectie 5 in reeks 6
#. . . implementatie functie valueattribuut: zie oefening 1

@ARGV == 1 or die "geef als enige parameter de naam van de ou relatief t.o.v. de container ou=labo,dc=hogent,dc=hogent,dc=be\n";
my $ou_naam=$ARGV[0];
my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();

my $ou=bind_object("ou=".$ou_naam.",ou=labo,".$RootObj->{defaultNamingContext});

wis($ou);

print "controle, de container ".ou->{name}." bevat: ";
foreach (in $ou){
     print "\n",$_->{name};
}

sub wis{
   my $ou=shift;
   foreach (in $ou){

     print $_->{adspath}. " wissen ok (j=ja) ?\n";
     chomp($antw=<STDIN>);
     if ($antw eq "j"){
         wis($_);
         $ou->delete ($_->{class},$_->{name});
     }
   }
 }
