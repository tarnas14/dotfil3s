for script in ./installationScripts/*
do
  if [ -f $script -a -x $script ]
	then
    $script $1
	fi
done
