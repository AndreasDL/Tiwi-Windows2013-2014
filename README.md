Tiwi-Windows2013-2014
=====================

Work done for Windows course 2013-2014 , Tiwi-UGent.
Everything below is in Dutch, since this code probably won't have a lot of use.

**Windows 2013-2014 , Tiwi - UGent**
* labo -> Labo oefeningen (perl) + examen vraag van 1e zit 2013-2014 in LDAP
* theorie -> theorie vragen (latex)
* archive -> oude samenvattingen (van inwe.be)

**Needed - labo:**
* Windows server 2008 SP1 or SP2
* oleview
* perl
* ms office excel 2007
* adsiedit

**Notes:**

***Labo***
* overal strict & warnings modules gebruikt.
* ik heb niet alle alle oefeningen gemaakt, maar wel het grootste deel. Anderzijds is niet elke oefening een script.
* Bij volgende stukken code moet je user en pass nog infullen
```
sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://" ) . $par );
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			"<user>",
			"<password>",
			1
		);
	}
}
```
 en
```
my $con = Win32::OLE->CreateObject("ADODB.Connection");
   $con->{Provider} = "ADsDSOObject";
   $con->{Properties}->{"User ID"}  = "<user>";
   $con->{Properties}->{"Password"} = "<password>";
   $con->{Properties}->{"Encrypt Password"} = 1;
   $con->Open();
```


***Theorie:***
* Gebaseerd op gevonden samenvattingen op inwe.be (waarvoor denk)
* Het is aan te raden van de cursus toch minstens eenmaal te lezen. Ik heb deze vragen uitgeschreven zodat ik ze beter zou onthouden.
