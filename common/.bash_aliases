# vim: set ft=bashrc
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias fixdns='sudo resolvconf -u'
alias sb='source ~/.bashrc'
alias eb='$EDITOR ~/.bashrc'
alias dot='cd ~/.dotfiles'
alias ee='emacs -nw'

alias tmux='tmux -2'
alias ta='tmux attach-session -t 0'
alias tl='tmux list-session'

alias ll='ls -alF'
alias ee='emacs -nw'
alias ez="$EDITOR ~/.zshrc"
alias v="$EDITOR"
alias vim="$EDITOR"
alias vimdiff="$EDITOR -d"
alias sz='source ~/.zshrc'
alias g="git"
alias wgdl='wget --recursive --no-clobber --convert-links --html-extension --page-requisites --no-parent '

alias ta='tmux attach-session -t 0'
alias tl='tmux list-session'

alias drun='docker run -it --rm --network host'

alias fuck='$EDITOR $(git diff --name-only | uniq)'
