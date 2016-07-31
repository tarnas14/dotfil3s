dotfil3s_root=`pwd`
link:
	if [ ! -e "$(HOME)/.tmux.conf" ]; then\
		ln -s $(dotfil3s_root)/.tmux.conf $(HOME)/.tmux.conf;\
	fi
	if [ ! -e "$(HOME)/.gitconfig" ]; then\
		ln -s $(dotfil3s_root)/.gitconfig $(HOME)/.gitconfig;\
	fi
	if [ ! -e "$(HOME)/.gitignore_global" ]; then\
		ln -s $(dotfil3s_root)/.gitignore_global $(HOME)/.gitignore_global;\
	fi
	echo "all linked"
.PHONY: link 
