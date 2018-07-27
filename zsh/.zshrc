#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
# Turn off bell
setopt no_beep
setopt NO_LIST_BEEP
set bell-style none

# Path
path+=(~/.fabric8/bin) 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
