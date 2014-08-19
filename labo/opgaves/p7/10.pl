#dsquery * "cn=configuration,dc=iii,dc=hogent,dc=be" -filter "(fromServer=*)" -attr objectclass
#onderstaande query geeft geen resultaten
#dsquery * "cn=configuration,dc=iii,dc=hogent,dc=be" -filter "(fromServer=*be)" -attr objectclass

#Vervang in de oplossing enkel de "base" in:
my $RootObj=bind_object("RootDSE");
   $RootObj->getinfo();
   $sBase .= $RootObj->{configurationNamingContext};
   
#En geef als argument "fromServer"


