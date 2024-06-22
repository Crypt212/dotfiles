#### Defaults

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt




#### My Customizations

## Auto-start

neofetch

## Default editor

export EDITOR='nvim'
export VISUAL='nvim'

## Aliases

alias ls='ls --color=auto'
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

## Prompt Customization

# Colors

# foreground
BlackFG='\[\033[30m\]'
BlueFG='\[\033[34m\]'
CyanFG='\[\033[36m\]'
GreenFG='\[\033[32m\]'
PurpleFG='\[\033[35m\]'
RedFG='\[\033[31m\]'
WhiteFG='\[\033[37m\]'
YellowFG='\[\033[33m\]'

# background
BlackBG='\[\033[40m\]'
BlueBG='\[\033[44m\]'
CyanBG='\[\033[46m\]'
GreenBG='\[\033[42m\]'
PurpleBG='\[\033[45m\]'
RedBG='\[\033[41m\]'
WhiteBG='\[\033[47m\]'
YellowBG='\[\033[43m\]'

# attributes
PlainT='\[\033[;0m\]'
BoldT='\[\033[;1m\]'
DimT='\[\033[;2m\]'
UnderlineT='\[\033[;4m\]'
BlinkingT='\[\033[;5m\]'
ReversedT='\[\033[;7m\]'
HiddenT='\[\033[;8m\]'

# Prompt
PS1="${debian_chroot:+($debian_chroot)}| $PlainT$PurpleFG\u$BoldT$WhiteFG@$RedFG\h$WhiteFG | $BlueFG\w$WhiteFG ~>$PlainT "
