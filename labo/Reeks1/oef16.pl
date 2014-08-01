use strict;
use warnings;
use Win32::OLE;
use Win32::OLE::Const;

$Win32::OLE::Warn = 3;

my $obj = Win32::OLE->new("CDO.Configuration");
my %map = %{Win32::OLE::Const->Load($obj)};

foreach (sort { $b cmp $a } keys %map){
	printf "%30s : %s\n", $_ , $map{$_} if ($_ =~ /SendUsing/ || $_ =~ /SMTPServer/);

}