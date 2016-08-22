for script in ./nvim-plugin-setup-scripts/*
do
  if [ -f $script -a -x $script ]
  then
    $script
  fi
done
