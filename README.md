# StartRL
Setting up reinforcement learning environments on ubuntu with one command. All packages are self-hosted on NJU Box to accelerate downloading. 

Based heavily on [typoverflow/.dotfiles](https://github.com/typoverflow/.dotfiles).

## Usage
1. clone this repo.
    ```bash
    git clone https://github.com/Nickydusk/StartRL.git
    ```

2. run a script.
    ```bash
    cd StartRL
    bash install_mujoco.sh
    ```

## Environments

### StarCraft II
versions: 4.6 / 4.10
```bash
bash install_sc2.sh
```

### MuJoCo 
versions: 200 / 210
```bash
bash install_mujoco.sh
```

### Isaac Gym
versions: preview 4
```bash
bash install_isaacgym.sh
```
