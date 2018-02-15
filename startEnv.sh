docker run -it --rm \
  -p 3000:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 -p 3004:3004 \
  --mount type=bind,src=/home/tarnas/dotfil3s,dst=/home/tarnasenv/dotfil3s \
  --mount type=bind,src=/home/tarnas/projects,dst=/home/tarnasenv/projects \
  --mount type=bind,src=/home/tarnas/Dropbox/todos,dst=/home/tarnasenv/todos \
  --mount type=bind,src=/home/tarnas/secure,dst=/home/tarnasenv/secure \
  --mount type=bind,src=/home/tarnas/.tmux/dockerized-resurrect,dst=/home/tarnasenv/.tmux/resurrect \
  --mount type=bind,src=/home/tarnas/.gnupg,dst=/home/tarnasenv/.gnupg \
  tarnasenv
