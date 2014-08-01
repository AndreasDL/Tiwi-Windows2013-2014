use strict;
use warnings;
use Win32::OLE;
use Win32::OLE::Const ".*CDO";
use Win32::OLE::Const ".*Excel";

#errors
$Win32::OLE::Warn = 3;

#test
print "\ncdoSendUsingPort : ", cdoSendUsingPort;
print "\nxlHorizontaal : ", xlHorizontal;
print "\nniet bestaand : ", xlHorizontaal;