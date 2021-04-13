FROM centos:7.4.1708

RUN yum install -y --nogpgcheck \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN yum install -y --nogpgcheck \
        cmake \
        ctags \
        curl \
        fuse-sshfs \
        gcc \
        gdb \
        git \
        glibc-devel \
        htop \
        iproute \
        libevent-devel \
        libstdc++-devel \
        make \
        net-tools \
        nmap \
        ncurses-devel \
        # This package forces a release upgrade to centos 7.8 which breaks linkage in some of the \
        # debesys builds. Just live without it for now. \
        # openldap-devel \
        openssh-server \
        procps-ng \
        python3 \
        python3-pip \
        ruby \
        rubygem-erubis \
        stow \
        sudo \
        sysvinit-tools \
        tcpdump \
        wget \
        xclip \
        xsel \
        zsh

# Install nvim and the plugin manager thing.
RUN cd /tmp \
        && wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
        && chmod +x nvim.appimage \
        && ./nvim.appimage --appimage-extract \
        && mv squashfs-root /opt/nvim-appimage \
        && ln -s /opt/nvim-appimage/AppRun /usr/local/bin/nvim \
        && rm -f /tmp/nvim.appimage \
        && curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install a newish tmux.
RUN cd /tmp \
        && export tmux_version=2.6 \
        && wget https://github.com/tmux/tmux/releases/download/$tmux_version/tmux-$tmux_version.tar.gz \
        && tar xf tmux-$tmux_version.tar.gz \
        && cd tmux-$tmux_version \
        && ./configure \
        && make -j$(nproc) \
        && mv tmux /usr/local/bin/ \
        && rm -rf tmux* \
        && unset tmux_version

# Take a username and userid as build arguments.  Require them using the test -n hack.
ARG user
ARG userid
ENV _user=$user
ENV _userid=$userid
RUN test -n "$_user"
RUN test -n "$_userid"

# My specific repo directory.  Weird to force this on people but too lazy to arg-ify yet...
VOLUME /home/$user/dev-root

# Configs.  Pretty universal.
VOLUME /etc/debesys

# By creating a container user with the same userid as the host os, permissions
# on the shared repo "just work".  Similar to the squashuid thing in nfs.
RUN useradd -u $userid $user -s /bin/zsh \
        && chown -R $user /var \
        && chown -R $user /opt

RUN mkdir -p /var/log/debesys

RUN echo "$user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user

# Expose the fact that we're in a container via a simple env var so we can do
# custom prompts inside the container terminal.
ENV _DOCKER 1

# Install sshd
RUN sshd-keygen
RUN chown root /var/empty/sshd

RUN mkdir /home/$user/.ssh
ADD authorized_keys /home/$user/.ssh/authorized_keys
RUN chown -R $user:$user /home/$user/.ssh

# Not sure how I broke this.  Just slam it back to the correct privs.
RUN chown $user:$user /home/$user

# key-based auth only please.
RUN sed -i 's/#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/#?PubkeyAuthentication no/PubkeyAuthentication no/'      /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
