// Crea il file di settings con i settings presi da BigFix, e se i settings non sono
// avvalorati in BigFix, vengono impostati ad un valore standard, in questo caso è 0000

parameter "file" = {if (name of operating system is "Win10") then "C:\windows\besbase.cfg" else "/etc/besbase.cfg"}
createfile until _EOF_
{(name of it & "=" & value of it & "%0d%0a") of settings whose (exists name whose (set of ("Customer"; "WSUSGroup") contains it) of it AND exists value whose (it != "") of it) of client}
{(name of it & "=" & "0000" & "%0d%0a") of settings whose (exists name whose (set of ("Customer"; "WSUSGroup") contains it) of it AND not exists value whose (it != "") of it) of client}_EOF_
delete "{parameter "file"}"
copy __createfile "{parameter "file"}"