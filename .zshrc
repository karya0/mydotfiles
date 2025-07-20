# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Customize to your needs...

source ~/.shellrc

# Comment the following lines if not needed
bindkey    "^[[1;5D"	backward-word
bindkey    "^[[1;5C"	forward-word

setopt no_share_history

# History settings.
HISTSIZE=5000000
SAVEHIST=5000000
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Case insensitive autocomplete
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Syntax highlighting
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Global aliases; expanded anywhere on the line.
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'


LASTCMD_START=0
function microtime()
{
  if [[ $(uname) == "Darwin" ]]; then
    gdate +%s.%N
  else
    date +%s.%N
  fi
}

function set_titlebar() {
  [[ "$TERM" = "xterm" ]] && echo -n $'\e]0;'"$@"'\a'
}

#called before user command
function preexec(){
  set_titlebar $HOST\$ "$1"
  LASTCMD_START=`microtime`
  LASTCMD="$1"
}

#called after user cmd
function precmd(){
  set_titlebar "$HOST:`echo "$PWD" | sed "s@^$HOME@~@"`"
  local T=0 ; (( T = `microtime` - $LASTCMD_START ))
  if (( $LASTCMD_START > 0 )) && (( T > 1 ))
  then
    T=`echo $T | head -c 10`
    LASTCMD=`echo "$LASTCMD" | grep -ioG '^[a-z0-9./_-]*'`
    echo "$fg[gray]$LASTCMD took $T seconds"
  fi
  LASTCMD_START=0
}

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Created by `pipx` on 2025-05-06 16:22:58
export PATH="$PATH:/Users/kapila/.local/bin"
# Lima BEGIN
# Make sure iptables and mount.fuse3 are available
PATH="$PATH:/usr/sbin:/sbin"
export PATH
# Lima END
