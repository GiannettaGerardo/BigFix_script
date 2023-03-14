<# array creato tramite relevance, per questo contiene una stringa vuota alla fine da eliminare #>
$arr = @('Customer, 2', 'WSUSGroup, 0001', 'Ultimo, 01010', 'NonCiSono, 9099', '')
[System.Collections.ArrayList]$arr = $arr[0..($arr.count - 2)]

<# controllo se la relevance non ha ritornato niente #>
if ($arr.Count -eq 1 -and $arr[0] -eq '') { return }

<# creo una matrice di settings e corrispondenti valori (N righe x 2 colonne) #>
$settings = [System.Collections.ArrayList]::new()
foreach ($str in $arr) {
  [System.Collections.ArrayList]$mid_arr = $str.Split(",").Trim()
  [void]$settings.Add($mid_arr)
}

$settings_file_path = "C:\Users\ggiannetta\OneDrive - Exprivia Spa\Documenti\BigFix\prova.txt"

<# scompongo il file di settings in un vettore di stringhe: 
 # ogni linea del file contiene un setting, quindi ogni linea è una stringa nel vettore #>
$all = [System.Collections.ArrayList]::new()
foreach ($line in Get-Content $settings_file_path) {
  [void]$all.Add($line)
}