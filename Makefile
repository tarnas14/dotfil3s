dotfil3s_root=`pwd`
link:
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
	if [ ! -e "$(HOME)/.tmux" ]; then\
		mkdir "$(HOME)/.tmux";\
		mkdir "$(HOME)/.tmux/plugins";\
		ln -s $(dotfil3s_root)/tpm $(HOME)/.tmux/plugins/tpm;\
	fi
	if [ -e "$(HOME)/.tmux.conf" ]; then\
		rm $(HOME)/.tmux.conf;\
	fi
	ln -s $(dotfil3s_root)/.tmux.conf $(HOME)/.tmux.conf;
	if [ -e "$(HOME)/.zshrc" ]; then\
		rm $(HOME)/.zshrc;\
	fi
	ln -s $(dotfil3s_root)/.zshrc $(HOME)/.zshrc;
	echo "all linked"
.PHONY: link 
