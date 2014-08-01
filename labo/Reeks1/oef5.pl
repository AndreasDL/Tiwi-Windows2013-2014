use strict;
use warnings;
use Win32::OLE;

my $cdo = Win32::OLE->new("CDO.Message");
my $count = Win32::OLE->EnumAllObjects(
	sub {
		my $Object = shift; #get the object

		#print ref & /-joined types
		printf "\n%-30s : %s", ref($Object), join(" / ", Win32::OLE->QueryObjectType($Object));

	}
);

print "\n$count Objects found!";