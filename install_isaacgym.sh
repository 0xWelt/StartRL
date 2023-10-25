install_isaacgym() {
    source utils.sh
    check_conda_env

    ENV_ROOT=$HOME/envs
    if [ ! -d $ENV_ROOT ]; then
        mkdir -p $ENV_ROOT
    fi

    pushd $ENV_ROOT
    if [ ! -d "./isaacgym" ]; then
        wget --content-disposition https://box.nju.edu.cn/f/fdffcbda1acf4293afba/\?dl\=1
        tar -xzvf IsaacGym_Preview_4_Package.tar.gz
        rm IsaacGym_Preview_4_Package.tar.gz
    fi
    pip install ./isaacgym/python
    popd
}

install_isaacgym