use strict;
use warnings;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

my $mail = Win32::OLE->new("CDO.Message");
   $mail->{TextBody} = "hallo";
   $mail->{Subject}  = "com";
   $mail->{From}     = "andreasdelille\@hotmail.com";
   $mail->{To}		 = "andreasdelille\@hotmail.com";
print $mail->{Configuration}->{Fields}->{Count} , "objecten";

#print all objects in the configuration part
foreach (in $mail->{Configuration}->{Fields}){
	print "\n",join(" / ", Win32::OLE->QueryObjectType($_));
}

#lso possible to create a standalone config object