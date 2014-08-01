use strict;
use warnings;
use Cwd;
use Win32::OLE qw(in with);

print "curDir : ", getcwd();
while ( my ($key => $val)= each %INC ){
	print "\$INC[$key] = $val\n";
}