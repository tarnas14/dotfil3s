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
	if [ ! -e "$(HOME)/.config" ]; then\
		mkdir "$(HOME)/.config";\
	fi
	if [ ! -e "$(HOME)/.config/nvim" ]; then\
		ln -s $(dotfil3s_root)/nvim $(HOME)/.config/nvim;\
	fi
	if [ ! -e "$(HOME)/scripts" ]; then\
		ln -s $(dotfil3s_root)/scripts $(HOME)/scripts;\
	fi
	echo "all linked"
.PHONY: link 
