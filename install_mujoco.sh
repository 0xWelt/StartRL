install_mujoco_200() {
    # # --- Install dependencies
    # sudo apt-get install patchelf libosmesa6-dev

    # --- Download key
    if [ ! -d "$MUJOCO_ROOT/mjkey.txt" ]; then
        log "Downloading mjkey.txt ..."
        wget -O "$MUJOCO_ROOT/mjkey.txt" https://box.nju.edu.cn/f/ff8b943199da4c7aa498/?dl=1
    else
        log "mjkey.txt already downloaded!"
    fi

    # --- Download mujoco200
    if [ ! -d "$ENV_ROOT/mujoco210" ]; then
        log "Downloading mujoco200 ..."
        pushd $ENV_ROOT
        wget --content-disposition https://box.nju.edu.cn/f/1ee7095724964d16a476/?dl=1
        unzip mujoco200_linux.zip
        rm -rf mujoco200_linux.zip
        popd
    else
        log "mujoco200 already downloaded!"
    fi

    # --- Add simlinks
    rm -rf $MUJOCO_ROOT/mujoco200
    rm -rf $MUJOCO_ROOT/mujoco200_linux
    ln -s $ENV_ROOT/mujoco200 $MUJOCO_ROOT/mujoco200
    ln -s $ENV_ROOT/mujoco200 $MUJOCO_ROOT/mujoco200_linux

    # --- Add environment variables
    if [[ ! $LD_LIBRARY_PATH =~ .*"/usr/lib/nvidia".* ]]; then
        echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia' >>$RC_FILE
    fi
    if [[ ! $LD_LIBRARY_PATH =~ .*"/mujoco200/bin".* ]]; then
        echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'"$MUJOCO_ROOT"'/mujoco200/bin' >>$RC_FILE
    fi
    if [[ ! $LD_LIBRARY_PATH =~ .*"/mujoco200_linux/bin".* ]]; then
        echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'"$MUJOCO_ROOT"'/mujoco200_linux/bin' >>$RC_FILE
    fi
    log "Adding environment variables to $RC_FILE successfully!"
    succ "Mujoco200 installed, but you still need to install mujoco_py-2.0 to get it work."
}

install_mujoco_210() {
    # # --- Install dependencies
    # sudo apt-get install patchelf libosmesa6-dev

    # --- Download mujoco210
    if [ ! -d "$ENV_ROOT/mujoco210" ]; then
        log "Downloading mujoco210 ..."
        pushd $ENV_ROOT
        wget --content-disposition https://box.nju.edu.cn/f/6ed1d2e606c444f7a8b9/?dl=1
        tar -xzvf mujoco210-linux-x86_64.tar.gz
        rm -rf mujoco210-linux-x86_64.tar.gz
        popd
    else
        log "mujoco210 already downloaded!"
    fi

    # --- Add simlinks
    rm -rf $MUJOCO_ROOT/mujoco210
    rm -rf $MUJOCO_ROOT/mujoco210_linux
    ln -s $ENV_ROOT/mujoco210 $MUJOCO_ROOT/mujoco210
    ln -s $ENV_ROOT/mujoco210 $MUJOCO_ROOT/mujoco210_linux

    # --- Add environment variables
    if [[ ! $LD_LIBRARY_PATH =~ .*"/usr/lib/nvidia".* ]]; then
        echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia' >>$RC_FILE
    fi
    if [[ ! $LD_LIBRARY_PATH =~ .*"/mujoco210/bin".* ]]; then
        echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'"$MUJOCO_ROOT"'/mujoco210/bin' >>$RC_FILE
    fi
    if [[ ! $LD_LIBRARY_PATH =~ .*"/mujoco210_linux/bin".* ]]; then
        echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'"$MUJOCO_ROOT"'/mujoco210_linux/bin' >>$RC_FILE
    fi
    log "Adding environment variables to $RC_FILE successfully!"
    succ "Mujoco210 installed, but you still need to install mujoco_py-2.1 to get it work."
}

install_mujoco() {
    source utils.sh

    # only supports ubuntu
    if [ ! $OS == "Ubuntu" ]; then
        error "Only support installing mujoco on Ubuntu."
        exit 1
    fi

    ENV_ROOT=$HOME/envs
    if [ ! -d $ENV_ROOT ]; then
        mkdir -p $ENV_ROOT
    fi
    MUJOCO_ROOT="${HOME}/.mujoco"
    if [ ! -d $MUJOCO_ROOT ]; then
        mkdir -p $MUJOCO_ROOT
    fi

    VERSIONS=("200" "210")
    warn "which version of mujoco to install?"
    echo -n "(${VERSIONS[@]}) > "
    read
    select_version=$REPLY

    if [[ $select_version == "200" ]]; then
        install_mujoco_200
    elif [[ $select_version == "210" ]]; then
        install_mujoco_210
    else
        error "Version '$select_version' not support. " && exit 1
    fi
}

install_mujoco
