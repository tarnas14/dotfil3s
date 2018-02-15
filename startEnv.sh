docker run -it --rm \
  --mount type=bind,src=/home/tarnas/dotfil3s,dst=/home/tarnasenv/dotfil3s \
  --mount type=bind,src=/home/tarnas/projects,dst=/home/tarnasenv/projects \
  --mount type=bind,src=/home/tarnas/Dropbox/todos,dst=/home/tarnasenv/todos \
  --mount type=bind,src=/home/tarnas/secure,dst=/home/tarnasenv/secure \
  --mount type=bind,src=/home/tarnas/.tmux/dockerized-resurrect,dst=/home/tarnasenv/.tmux/resurrect \
  --mount type=bind,src=/home/tarnas/.gnupg,dst=/home/tarnasenv/.gnupg \
  tarnasenv
