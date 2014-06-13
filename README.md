blukat-config
=============

blukat-config is collection of config files for bash, vim, [tmux].

Tested with
 - Ubuntu 8.04
 - bash 3.2.39
 - git 1.9.0
 - tmux 1.8
 - $TERM=xterm or linux

Installation
------------
  
  ```sh
  git clone https://github.com/blukat29/blukat-config.git
  cd blukat-config
  sh config-blukat.sh
  ```
This commands will automatically install vim [Bundle] plugin and replace any existing .bashrc, .vimrc, .tmux.conf files in home directory.

If your workspace has no tmux installed and you are not sudo, run

  ```sh
  run tmux_local_install.sh
  ```

This script is borrowed from https://gist.github.com/ryin/3106801

[Bundle]:https://github.com/gmarik/Vundle.vim
[tmux]:http://tmux.sourceforge.net/
