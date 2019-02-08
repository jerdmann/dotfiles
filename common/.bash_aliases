# vim: set ft=bashrc
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias fixdns='sudo resolvconf -u'
alias sb='source ~/.bashrc'
alias eb='$EDITOR ~/.bashrc'
alias deb='cd $(pwd | grep dev-root | cut -f1-5 -d\/) || echo "Not in a repo under dev-root."'
alias dev='cd ~/dev-root'
alias dot='cd ~/.dotfiles'
alias ee='emacs -nw'

alias tmux='tmux -2'
alias ta='tmux attach-session -t 0'
alias tl='tmux list-session'

alias ll='ls -alF'
alias dot='cd ~/.dotfiles'
alias ee='emacs -nw'
alias ez="$EDITOR ~/.zshrc"
alias v="$EDITOR"
alias vim="$EDITOR"
alias vimdiff="$EDITOR -d"
alias sz='source ~/.zshrc'
alias g="git"
alias dbd='smbclient -U jerdmann -W intad //chifs01.int.tt.local/Share'
alias wgdl='wget --recursive --no-clobber --convert-links --html-extension --page-requisites --no-parent '
alias pdc='price_decoder --dedup -f'

alias ta='tmux attach-session -t 0'
alias tl='tmux list-session'

alias cdws='cd /usr/lib/x86_64-linux-gnu/wireshark/plugins/1.12.1'

