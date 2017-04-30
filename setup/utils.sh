command_exists () {
    type "$1" &> /dev/null ;
}

wait_for_user () {
  read -n1 -r -p "$1\nPress anything to continue" key
}

dotfil3s_root="`pwd`/../"
