$Win32::OLE::Warn = 1; #toevoegen omdat de fout het script niet zou stopen
#Wijzig de volgende methode:

sub isset{
   my ($user,$prop)=@_;
   $user->GetInfoEx([$prop],0);# vraag expliciet om prop in de cache te plaatsen
   return $user->GetEx($prop);# array referentie, undef indien niet ingevuld 
}

#regel (1) in de oplossing wijzigt in: toon($prop,$k)

#de methode toon verandert ook

sub toon {
    my ($prop,$tabelref)=@_;
    $prefix=$prop;
    printlijn( \$prefix, $_ ) foreach @{$tabelref};
}




