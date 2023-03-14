<# 
 # Effettua un controllo completo della linea di file rispetto al setting passato.
 # @param [string]$setting setting da confrontare con la linea del file.
 # @param [string]$line linea del file da controllare.
 # @return boolean True se linea e il setting coincidono, False altrimenti.
 #>
function check_setting_line { param ([string]$setting, [string]$line)
  $setting_len = $setting.Length
  $line_len = $line.Length
  if ($setting_len -eq $line_len) {
    return $line -eq $setting
  }
  if ($setting_len -lt $line_len) {
    return ($line.Substring(0, $setting_len) -eq $setting) -and
           ($line[$setting_len] -eq '=')
  }
  return $false
}

function main {
  <# array creato tramite relevance, per questo contiene una stringa vuota alla fine da eliminare #>
  <# relevance: $arr=({("'" & name of it, value of it & "', ") of settings whose (exists name whose (set of ("Customer"; "WSUSGroup") contains it) of it) of client}'') #>
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

  <# creo un array di flag per determinare la presenza o assenza di un setting nel file #>
  $exists_flags = [System.Collections.ArrayList]::new()
  for ($i=0; $i -lt $settings.count; $i++) {
    [void]$exists_flags.Add(0)
  }

  $settings_file_path = "C:\Users\ggiannetta\OneDrive - Exprivia Spa\Documenti\BigFix\prova.txt"

  <# scompongo il file di settings in un vettore di stringhe: 
  # ogni linea del file contiene un setting, quindi ogni linea è una stringa nel vettore #>
  $all = [System.Collections.ArrayList]::new()
  foreach ($line in Get-Content $settings_file_path) {
    [void]$all.Add($line)
  }

  <# Ricerco, sostituisco e segnalo la presenza dei settings nel vettore generale #>
  for ($j=0; $j -lt $all.count; $j++) {
    for ($i=0; $i -lt $settings.count; $i++) {
      if (check_setting_line -Setting $settings[$i][0] -Line $all[$j]) {
        $all[$j] = $settings[$i][0] + "=" + $settings[$i][1]
        $exists_flags[$i] = 1
        break
      }
    }
  }

  <# check and add the non-existent settings #>
  for ($i=0; $i -lt $exists_flags.count; $i++) {
    if ($exists_flags[$i] -eq 0) {
      [void]$all.Add($settings[$i][0] + "=" + $settings[$i][1])
    }
  }

  <# recreate the file #>
  Remove-Item $settings_file_path
  foreach ($line in $all) {
    Add-Content $settings_file_path $line
  }

  Write-Output "FINALE"
  Get-Content $settings_file_path
}

main