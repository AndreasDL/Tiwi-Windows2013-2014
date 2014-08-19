use Win32::OLE;

$cdo = Win32::OLE->new("CDO.Message");
print "CDO.Message: ", ref($cdo), " -- ",join(" / ",Win32::OLE->QueryObjectType($cdo));

