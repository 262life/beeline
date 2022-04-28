###  Update code section

release="latest/download"  #<-- to test: release="download/v2.2.0-RC1"
ok_file="${HOME}/.beeline.ok"
days=7

if [[ $(find ${ok_file} -mtime +${days}) = "$ok_file" ]]; then
  candidate=$(curl -s -L https://github.com/262life/beeline/releases/${release}/checksum.sha512)
  current=$(cat ~/.beeline.k8s | shasum -a 512)
  if [[ "$candidate" != "$current" ]] ; then

    # Ask for confirmation and only update on 'y', 'Y' or Enter
    # Otherwise just show a reminder for how to update
    echo -n "${cyan}[beeline] Would you like to update? ${white}[${cyan}Y/n${white}]${defcolor} "
    read -r -k 1 option
    [[ "$option" = $'\n' ]] || echo
    case "$option" in
      [yY$'\n']) update_beeline ;;
      [nN]) update_last_updated_file ;&
      *) echo "[beeline] You can update manually by ........" ;;
    esac
  fi
fi


update_last_updated_file() {

  touch  ${ok_file}

}

update_beeline() {

  curl -s -L https://github.com/262life/beeline/releases/${release}/beeline.sh > ${HOME}/x
  update_last_updated_file

}


