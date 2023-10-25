error() {
    echo >&2 -e "\033[31;1m[Error]\033[0m "$@
}

succ() {
    echo >&1 -e "\033[32;1m[Success]\033[0m "$@
}

warn() {
    echo >&1 -e "\033[33;1m[Warning]\033[0m "$@
}

log() {
    echo >&1 -e "\033[34;1m[Log]\033[0m "$@
}

# Get OS name and version
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

if [[ $OS != "Ubuntu" ]]; then
    error "Unsupported OS: $OS"
    exit 1
fi

# Get Shell name
SHELL_NAME=$(basename $SHELL)
if [[ $SHELL_NAME == "bash" ]]; then
    RC_FILE=$HOME/.bashrc
elif [[ $SHELL_NAME == "zsh" ]]; then
    RC_FILE=$HOME/.zshrc
else
    error "Shell $SHELL_NAME not support. " && exit 1
fi

try_install() {
    if [ ! -e $1 ]; then
        log "${@:2} not found, installing ${@:2} ..."
        if [ "$OS" = "Arch Linux" ]; then
            sudo pacman -S ${@:2}
        elif [ "$OS" = "Ubuntu" ]; then
            sudo apt-get install -y ${@:2}
        elif [ "$OS" = "Darwin" ]; then
            brew install ${@:2}
        else
            error "Unsupported OS: $OS"
            exit 1
        fi

        if [ $? -ne 0 ]; then
            error "${@:2} installation failed."
            exit 1
        else
            log "${@:2} installation succeeded."
        fi
    else
        log "found ${@:2} in $1."
    fi
}

# --- get the activated conda env name
get_activated_conda() {
    cmd='conda info | grep "active environment" | awk '"'{print \$4}'"
    eval $cmd
}

# --- check whether anaconda is installed
check_conda_installed() {
    if [ ! -d "$HOME/anaconda3" ]; then
        error "Anaconda3 not found in $HOME/anaconda3. Please install anaconda3, activate the virtual env you wish to install carla in. "
        exit 1
    fi
}

# --- check conda env
check_conda_env() {
    warn "Are you going to install in '$(get_activated_conda)' env? "
    echo -n "([y]/n, default yes) > "
    read
    case $REPLY in
    [Nn]o)
        error "Abort. " && exit 1
        ;;
    esac
}
