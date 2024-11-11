# vim: ft=zsh fdm=marker:

# Do nothing on non-interactive shell
[[ ! -o interactive ]] && return

WORDCHARS=${WORDCHARS/\/} # / is not word char
WORDCHARS=${WORDCHARS/\-} # - is not word char
WORDCHARS=${WORDCHARS/\_} # _ is not word char

setopt interactive_comments # Allow comments in interactive shell
setopt no_beep              # Don't beep on error
setopt ignore_eof           # Ignore <c-d> logout
setopt auto_cd              # auto change dir
setopt auto_pushd           # auto dir pushd that you can get dirs list by cd -[tab]

## Aliases {{{

# alias ls='exa --color=always --group-directories-first' # my preferred listing
# alias ll='exa -l --color=always --group-directories-first'  # long format
# alias la='exa -la --color=always --group-directories-first'  # all files and dirs
# alias lt='exa -aT --color=always --group-directories-first' # tree listing
# alias l.='exa -a | egrep "^\."'

# brew install coreutils
alias ls='gls -F --color=auto --group-directories-first'
alias ll='gls -Flh --color=auto --group-directories-first'
alias la='gls -Flha --color=auto --group-directories-first'
alias l.='gls -dlF .* --color=auto --group-directories-first'

alias g='grep'
alias -g G='| grep'
alias -g L='| less -S'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sed'

alias mkdir='mkdir -vp'
alias rm='rm -ivr'
alias cp='cp -ir'
alias mv='mv -i'
alias grep='grep --color=auto' # Colored grep output
[[ $OSTYPE =~ ^darwin.* ]] && alias grep='grep --colour=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

alias -s {mp4,mov}=mpv
alias -s {md,txt,log}=less -FMN
alias -s {pdf,epub}=zathura
alias -s {htm,html}=chromium

alias ep="echo ${PATH} | sed -e $'s/:/\\\n/g'"

if test "$TERM" = "xterm-kitty"; then
  alias ssh="kitty +kitten ssh"
fi

alias get="http get"
alias post="http post"

alias v="nvim"
alias vi="nvim"
alias vim="nvim"

## }}}

## History {{{

HISTSIZE=12345678
SAVEHIST=12345678
HISTFILE=$HOME/.zsh_history
setopt APPEND_HISTORY         # Allow multiple terminal sessions to all append to one zsh command history
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY            # Don't execute immediately upon history expansion.

## }}}

## Zinit {{{

autoload -Uz compinit && compinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Load pure theme
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting
# zinit light zdharma-continuum/history-search-multi-word
# zinit light joshskidmore/zsh-fzf-history-search
zinit light wfxr/forgit

zinit snippet OMZP::sudo
zinit snippet OMZP::gpg-agent
zinit snippet OMZP::ssh
zinit snippet OMZP::ssh-agent
zinit snippet OMZP::extract
zinit snippet OMZP::tmux
zinit snippet OMZP::fancy-ctrl-z
zinit snippet OMZP::rsync
zinit snippet OMZP::nmap
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::terraform
zinit snippet OMZP::ansible

## }}}

## Key Binding {{{

stty -ixon # Disable Ctrl+S, Ctrl+Q

bindkey -e

# History beginning search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search

# Enable edit-command-line
autoload -U edit-command-line
zle -N edit-command-line
# Allow ctrl+xe | ctrl+x ctrl+e to edit command line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

## }}}

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
