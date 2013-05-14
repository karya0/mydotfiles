if [ -z $SHELLRC_DEFINED ]; then
  source $HOME/.shellrc
fi

# History options.
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=5000000
export SAVEHIST=5000000
setopt hist_ignore_dups # ignore same commands run twice+

# Generic shell options.
#setopt nopromptcr     # don't add \n which overwrites cmds with no \n
setopt nobeep         # i hate beeps
#setopt noautomenu     # don't cycle completions
setopt autocd         # change to dirs without cd
setopt autopushd      # push directories by default
#setopt nocheckjobs    # don't warn me about bg processes when exiting
#setopt nohup          # and don't kill them, either
setopt completeinword # not just at the end
setopt alwaystoend    # when complete from middle, move cursor
setopt promptsubst    # do varaible fu in prompt
setopt extendedglob   # Nice things like *~*.c globs all but .c files
#setopt menucomplete

# Use emacs style editing
bindkey -e
#bindkey '^O' copy-prev-shell-word
# TRY: Esc-q pushes the current line then recalls it after 

# Comment the following lines if not needed
bindkey    "^[[1;5D"	backward-word
bindkey    "^[[1;5C"	forward-word

# Color STDERR line RED
#exec 2>>(while read line; do
#  print '\e[91m'${(q)line}'\e[0m' > /dev/tty; done &)


################################################################################
# Environment vars
################################################################################

export NUM_PROCESSORS=`cut -f 1 -d : < /proc/cpuinfo | grep -c processor`
export EDITOR=`which vim`
export PAGER=`which less`
export VISUAL="$EDITOR"
export MAKEFLAGS="-j $NUM_PROCESSORS"
export WINEDEBUG="fixme-all"

# pretty colorings 
eval `dircolors`

#hack for solaris
test `uname` = SunOS && export TERM=vt100

#add ~/bin to path
if [ -d ~/bin ] ; then
 if ! echo $PATH | grep ~/bin > /dev/null ; then
   PATH=~/bin:"${PATH}"
 fi
fi

test -d /usr/local/matlab && export MATLAB=/usr/local/matlab

export MACHINE=`uname -m`
export HOST=`uname -n`

################################################################################
# Prompt 
################################################################################

function hashcolor()
{
  case `echo $@ | md5sum | head -c 1` in
    [01]) echo red     ;;
    [23]) echo green   ;;
    [45]) echo blue    ;;
    [67]) echo grey    ;;
    [89]) echo magenta ;;
    [ab]) echo yellow  ;;
    [cd]) echo white  ;;
    [ef]) echo cyan    ;;
    *)    echo white ;;
  esac
}

if test -e ~/.hostcolor
then
  export HOSTCOLOR=`cat ~/.hostcolor`
else
  export HOSTCOLOR=$(hashcolor `uname -n -m`)
fi

autoload colors ; colors
clr1="%{$fg_bold[$HOSTCOLOR]%}"
clr2="%{$fg_bold[$HOSTCOLOR]%}"
clr3="%{$fg[grey]%}"
clreset="%{$reset_color%}"
dollarsign='>' #'$'
prettypwd="%(4~|...|)%3~"

HOSTDISPLAY="$"

if [[ "$MACHINE" = "x86_64" ]]; then
  BITCOUNT=$(file `which cat` | sed -e "s# #\n#g" | grep bit | cut -d - -f 1)
  if [[ "$BITCOUNT" = "32" ]]; then
    HOSTDISPLAY="$HOST+$clr2""32bit$clr1"
  fi
fi

function makePS1()
{
  echo -n $clr1
  
  case "$USER" in
    kapil) 
    ;;
    root) 
      echo -n $clr2
      echo -n 'root@'
    ;;
    *) 
      echo -n "$USER@" 
    ;;
  esac
  
  echo -n "$HOSTDISPLAY:"
  echo -n $clreset
  echo -n $prettypwd
  echo -n $clr2
  echo -n $dollarsign
  echo -n $clreset 
  echo -n ' '
}

function makePS2()
{
  echo -n '%_'
  echo -n $clr2
  echo -n '>'
  echo -n $clreset
}

function makePSR()
{
  echo -n $clr3
  echo -n '%t'
  echo -n $clreset
}


PS1='`makePS1`'
PS2='`makePS2`'
#RPROMPT='`makePSR`'

#autoload -U promptinit; promptinit

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
  if (( $LASTCMD_START > 0 )) && (( T>1 ))
  then
    T=`echo $T | head -c 10` 
    LASTCMD=`echo "$LASTCMD" | grep -ioG '^[a-z0-9./_-]*'`
    echo "$fg[gray]$LASTCMD took $T seconds"
  fi
  LASTCMD_START=0
}

################################################################################
# Aliases
################################################################################
#
alias su='sudo -s'

# Suffix aliases. So wicked! Just typing a filename and hitting enter will
# launch the listed program with the file as the first argument.
#for ext in c cc cpp h hpp py tex
#    alias -s $ext=gvim
#for ext in bz2 gz tar tbz2 tgz zip Z
#    alias -s $ext=smartextract
#alias -s html=x-www-browser
#alias -s org=x-www-browser

alias -s gnuplot=gnuplot
alias -s plot=gnuplot
alias -s pdf=acroread
autoload -U zsh-mime-setup
zsh-mime-setup

# Global aliases; expanded anywhere on the line.
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
#alias -g CA="2>&1 | cat -A"
#alias -g C='| wc -l'
#alias -g G='| egrep --color'
#alias -g H='| head'
#alias -g L='| less'
#alias -g MM="2>&1 | most"
#alias -g N="> /dev/null 2>&1"

alias solaris='export TERM=vt100; PS1="$ "'
export LS_OPTIONS='--color=auto'
eval `dircolors`
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias ltr='ls $LS_OPTIONS -ltr'
alias l='ls $LS_OPTIONS -lAh'
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
alias -g vi='vim'
alias untgz='tar -xzvf'
alias p='ps -eHf f'
#alias dselect='screen su --command="dselect update select install"'
#alias ssh='ssh -X'
alias xtermcmd='xterm -e'
alias make='make -j5'

################################################################################
# Completion
################################################################################

[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
[ -f ~/.ssh/known_hosts ] && : ${(A)ssh_known_hosts:=${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}}
#zstyle ':completion:*:*:*' hosts $ssh_config_hosts $ssh_known_hosts
#zstyle ':completion:*' completer _expand _complete _correct _approximate

#stty sane

autoload -U compinit
compinit

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _correct 
zstyle ':completion:*' ignore-parents parent
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'r:|[.-_]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/|HEAD'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose false
zstyle :compinstall filename '/home/kapil/.zshrc'

# End of lines added by compinstall

#hacks to make completion suck less
export _ssh_users() {}


################################################################################
# Smart tools
################################################################################

autoload -U zmv
