use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting';
#$Win32::OLE::Warn = 3;

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost","root/cimv2");

my @classes = in $wbem->SubClassesOf("",wbemFlagUseAmendedQualifiers);

foreach my $class (@classes){
	my $methods = $class->{Methods_};
	next unless $methods->{Count};

	printf "%s contains %d methods with following params:\n",
		$class->{Path_}->{Class}, $methods->{Count};


	foreach my $method (sort{uc($a->{Name}) cmp $b->{Name}} in $methods){
		printf "\t%s " , $method->{Name};

		printf "IN: ( %s )\n", join(",", 
			map{ $_->{Qualifiers_}->{Optional} ? "[$_->{Name}]" : $_->{name} }#3. [] bij optionele params
			sort {uc($a->Qualifiers_("ID")->{Value}) cmp uc($b->Qualifiers_("ID")->{Value})} #2. sorteren op id
			in $method->{InParameters}->{Properties_}) #1. alle input params
		if $method->{InParameters}; #4. enkel als er inparams zijn

		printf "OUT: ( %s )\n", join(",",
			map{ $_->{Name} . ($_->Qualifiers_("ID") ? "(" . $_->Qualifiers_("ID")->{Value} . ")" : "") }
			in $method->{OutParameters}->{Properties_})
		if $method->{OutParameters} && $method->{OutParameters}->{Properties_}->{Count} > 1;

	}

}
#notworking