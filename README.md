# always work in progress

Every time I ask somebody about their dotfiles repo I hear something along the lines of "I've been planning to clean it up a bit"

Yes, I've also been planning to clean my dotfiles a bit... And I will get round to it eventually...
Oh and I just noticed that I already said that in the last line of this readme... smh

# dockerized setup

I setup a dockerized dev environment to learn some arch and avoid installing multiple stupid dependencies on host.
If you want to check it out, you can build it with
```bash
cd tarnas-dev-env
docker build -t tarnas-dev-env:core -f Dockerfile.core ../
```
Then I run it in the project directory like this:
```bash
docker run -it --rm -v ${PWD}:/home/tarnas/code tarnas-dev-env:core
```

## known issues

- [x] when running it in tmux, neovim colors are sometimes lost when navigating files :: upgrading tmux to 2.6 (from 2.3) fixed the issue oO
- [x] still investigating why there's a `q` character in weird places when running the docker - this comes up when you start vim in docker, like maybe it's doing something weird with the cursor? :: [SOLVED] (disabling gui cursor in Dockerfile) drawback: no nice cursor in insert mode, but hey...

# other stuff

also included but probably not easily reusable:
some install scripts for the 'other stuff'

// might clean this up more if I have time or some actual reason :D
