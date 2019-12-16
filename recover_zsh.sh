#!bin/bash

# For when you power off abruptly and zsh complains about a corrupted
# history file

mv .zsh_history .zsh_history_bad
strings .zsh_history_bad > .zsh_history
fc -R .zsh_history
