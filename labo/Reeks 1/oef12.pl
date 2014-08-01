use strict;
use warnings;
use Win32::OLE;
$Win32::OLE::Warn = 3;

my $mail = Win32::OLE->new("CDO.Message");
   $mail->{TextBody} = "hallo";
   $mail->{Subject}  = "com";
   $mail->{From}     = "andreasdelille@hotmail.com";
   $mail->{To}		 = "andreasdelille@hotmail.com";
