# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/prezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/prezto/init.zsh"
fi

# Customize to your needs...

source ~/.shellrc

# Comment the following lines if not needed
bindkey    "^[[1;5D"	backward-word
bindkey    "^[[1;5C"	forward-word

export HISTSIZE=5000000
export SAVEHIST=5000000
setopt hist_ignore_dups # ignore same commands run twice+
setopt no_share_history

# Global aliases; expanded anywhere on the line.
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'


LASTCMD_START=0
function microtime()    { date +%s.%N }
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
