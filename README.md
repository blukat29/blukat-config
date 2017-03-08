blukat-config
=============

blukat-config is a collection of config files.

## Components

- `basic.sh`: Installs the dotfiles. Original files are stored under `~/.config.bak.d`.
- `restore.sh`: Restore the original dotfiles.

- dotfiles
    - `bashrc`
    - `gdbinit`
    - `gitconfig`
    - `pythonrc.py`
    - `tmux.conf`
    - `vimrc`

- scripts: Scripts used just like another command line program.
    - `git-change-url`: Interchange git remote url between git-ssh and https formats.
    - `markd`: Run a small web server that renders specified markdown file.
    - `myip`: Determine host IP address.
    - `sqlite_runner.py`: `sqlite3` wrapper using `apsw`.
    - `tmux_status.py`: Tmux status bar content.
    - `vbox`: (over)simplified `VboxManage` command line tool.

- tools: Scripts that installs programs to this computer.
    - `change-apt-source.sh`: Edit `/etc/apt/source.list` urls.
    - `docker.bash`: Installs docker to Ubuntu.
    - `mac.bash`: Installs common tools to Mac.
    - `tags.sh`: Create ctags file from all system libraries.
    - `ubuntu-dev.bash`: Installs development tools to Ubuntu.
    - `ubuntu-sec.bash`: Installs security related tools to Ubuntu.

## Install

```sh
git clone https://github.com/blukat29/blukat-config.git
cd blukat-config
sh basic.sh
```

## Uninstall

```sh
sh restore.sh
```

