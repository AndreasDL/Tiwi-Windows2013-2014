use Win32::OLE::Const;
$Message = Win32::OLE->new("CDO.Message");
%wd = %{Win32::OLE::Const->Load($Message)}; #direct in een hash stoppen

foreach (sort {$b cmp $a} keys %wd){
    printf ("%30s : %s\n",$_,$wd{$_});
}  



