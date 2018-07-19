# vim: set ft=bashrc
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias fixdns='sudo resolvconf -u'
alias sb='source ~/.bashrc'
alias eb='vim ~/.bashrc'
alias deb='cd $(pwd | grep dev-root | cut -f1-5 -d\/) || echo "Not in a repo under dev-root."'
alias dev='cd ~/dev-root'
alias dot='cd ~/.dotfiles'
alias gvim='gvim --remote-silent'
alias ee='emacs -nw'

alias tmux='tmux -2'
alias ta='tmux attach-session -t 0'
alias tl='tmux list-session'

# various debesys scripts
alias tempvm='~/dev-root/debesys-one/run ~/dev-root/debesys-one/deploy/chef/scripts/temp_vm.py'
alias ec2='~/dev-root/debesys-one/run ~/dev-root/debesys-one/deploy/chef/scripts/ec2_instance.py'
alias bump='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/bump_cookbook.py'
alias checkrepo='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/check_repo.py'
alias deploy='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/request_deploy.py'
alias build='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/request_build.py'
alias knife-ssh='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/knife_ssh.py'
alias oneoff='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/deploy_one_off.py'
alias uenv='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/update_environment.py'

alias ll='ls -alF'
alias dot='cd ~/.dotfiles'
alias gvim='gvim --remote-silent'
alias ee='emacs -nw'
alias ez="vim ~/.zshrc"
alias v="vim"
alias ev="vim ~/.vimrc"
alias sz='source ~/.zshrc'
alias g="git"
alias dbd='smbclient -U jerdmann -W intad //chifs01.int.tt.local/Share'
alias wgdl='wget --recursive --no-clobber --convert-links --html-extension --page-requisites --no-parent '

alias ta='tmux attach-session -t 0'
alias tl='tmux list-session'

# debesys stuff
alias ttrun='`git rev-parse --show-toplevel`/run'
alias ttpy='`git rev-parse --show-toplevel`/run python'
alias cf='cd /etc/debesys'
alias lg='cd /var/log/debesys'

# project dirs
alias r1='cd ~/dev-root/debesys-one'
alias r2='cd ~/dev-root/debesys-two'
alias r3='cd ~/dev-root/debesys-three'
alias cb='cd `git rev-parse --show-toplevel`/deploy/chef/cookbooks'
alias cdps='cd `git rev-parse --show-toplevel`/price_server'
alias cdlh='cd `git rev-parse --show-toplevel`/price_server/exchange/test_lh'
alias cdsbe='cd `git rev-parse --show-toplevel`/price_server/ps_common/sbe_messages'
alias cdpro='cd `git rev-parse --show-toplevel`/the_arsenal/all_messages/source/tt/messaging'

alias cdws='cd /usr/lib/x86_64-linux-gnu/wireshark/plugins/1.12.1'

alias pstest='pushd `git rev-parse --show-toplevel` && sudo ./run helmsman tt.price_server.test.suites.test_price_client_basic_fix && popd'
alias psatest='pushd `git rev-parse --show-toplevel` && sudo ./run helmsman tt.price_server.test.suites.test_price_client_advanced_fix && popd'
