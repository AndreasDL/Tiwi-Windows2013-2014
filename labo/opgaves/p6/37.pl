# implementatie bind_object functie: zie sectie 5
@ARGV == 1 or die "Geef de ldapDisplayName van een klasse op als argument !\n";
my $argument=$ARGV[0];


my $abstracteKlasse  = bind_object( "schema/$argument" );


foreach ("adspath","class","GUID","name","parent","Schema"){
  printf "%20s : %s\n",$_,$abstracteKlasse->{$_};
}

print "Het overeenkomstig reeel object heeft cn=",$abstracteKlasse->get("cn");

