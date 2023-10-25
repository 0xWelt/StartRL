install_StarCraftII() {
    source utils.sh

    ENV_ROOT=$HOME/envs
    if [ ! -d $ENV_ROOT ]; then
        mkdir -p $ENV_ROOT
    fi

    # Install StarCraftII
    VERSIONS=("4.6" "4.10")
    warn "which version of StarCraftII to install?"
    echo -n "(${VERSIONS[@]}) > "
    read
    select_version=$REPLY
    if [[ $select_version == "4.10" ]]; then
        SC2PATH=$ENV_ROOT/StarCraftII_4.10
        if [ ! -d $SC2PATH ]; then
            pushd $ENV_ROOT
            wget --content-disposition https://box.nju.edu.cn/f/61ede46ef9f246dd833d/?dl=1
            unzip -P iagreetotheeula SC2.4.10.zip
            rm -rf SC2.4.10.zip
            mv StarCraftII $SC2PATH
            log "StarCraftII_$select_version installed successfully!"
            popd
        else
            log "StarCraftII_$select_version already installed!"
        fi
    elif [[ $select_version == "4.6" ]]; then
        SC2PATH=$ENV_ROOT/StarCraftII_4.6
        if [ ! -d $SC2PATH ]; then
            pushd $ENV_ROOT
            wget --content-disposition https://box.nju.edu.cn/f/535dd6fe72b24579aa62/?dl=1
            unzip -P iagreetotheeula SC2.4.6.2.69232.zip
            rm -rf SC2.4.6.2.69232.zip
            mv StarCraftII $SC2PATH
            log "StarCraftII_$select_version installed successfully!"
            popd
        else
            log "StarCraftII_$select_version already installed!"
        fi
    else
        error "Version '$select_version' not support. " && exit 1
    fi

    # Adding SC2PATH to .bashrc or .zshrc
    if grep -q "^export SC2PATH" $RC_FILE; then
        sed -i "s%^export SC2PATH.*%export SC2PATH=$SC2PATH%g" $RC_FILE # use % to avoid / in $SC2PATH
    else
        echo "export SC2PATH=$SC2PATH" >>$RC_FILE
    fi
    log "Adding environment variables to $RC_FILE successfully!"

    # Install SMACv2 maps
    MAP_DIR=$SC2PATH/Maps/SMAC_Maps
    if [ ! -d "$MAP_DIR" ]; then
        mkdir -p $MAP_DIR
        pushd $MAP_DIR
        wget --content-disposition https://box.nju.edu.cn/f/635dc133679d40c9b885/?dl=1
        unzip SMAC_Maps.zip
        rm -rf SMAC_Maps.zip
        log 'SMAC maps installed successfully!'
        popd
    else
        log 'SMAC maps already installed!'
    fi

    succ "StarCraftII installed successfully!"
}

install_StarCraftII
