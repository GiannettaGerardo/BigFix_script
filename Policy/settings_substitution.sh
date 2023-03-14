#!/bin/bash

main() {
# array creato tramite relevance,
  settings=('lol' '0003' 'Customer' '10' 'Super' '0001' 'WSUSGroup' '8999' )

# controllo se la relevance non ha ritornato niente
  if [ "${#settings[@]}" -eq 0 ] || (( ${#settings[@]} % 2 ))
  then
    echo "Incorrect relevance values"
    exit 1
  fi

  write_flag=0 # this flag choose if we have to write the settings file or not
  file_path="/c/Users/ggiannetta/OneDrive - Exprivia Spa/Documenti/BigFix/prova.txt"
  file_array=()

# scompongo il file in un array di stringhe ed eseguo uno split sul carattere '='
# poi ricerco, sostituisco e segnalo la presenza dei settings nel vettore generale
  while read -r line
  do
    IFS='=' read -ra SPLIT <<< "$line"
    for (( i=0; i<${#settings[@]}; i += 2 ))
    do
      if [ "${SPLIT[0]}" == "${settings[$i]}" ]
      then
        file_array+=( "${settings[$i]}=${settings[(( i + 1 ))]}" )
        # i settings non vuoti saranno visti come settings avanzati,
        # non presenti nel file, ma da inserire successivamente
        settings[$i]=''
        # se i valori non combaciano, allora bisogna modificare il file
        if [ "${SPLIT[1]}" != "${settings[(( i + 1 ))]}" ]
        then
          write_flag=1
        fi
        break
      fi
    done
  done < "$file_path"

# cerco eventuali settings mancanti nel file e se ne trovo, imposto il flag di scrittura
  for (( i=0; i<${#settings[@]}; i += 2 ))
  do
    if [ '' != "${settings[$i]}" ]
    then
      write_flag=1
      file_array+=( "${settings[$i]}=${settings[(( i + 1 ))]}" )
    fi
  done

# se il flag di scrittura è 1, allora il file deve essere modificato
  if [ "$write_flag" -eq 1 ]
  then
    rm "$file_path"
    for t in ${file_array[@]}
    do
      echo "$t" >> "$file_path"
    done
  fi
}

main
exit 0
