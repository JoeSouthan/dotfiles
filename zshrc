# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. ~/.oh-my-zsh/themes/
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
autoload -Uz compinit

case $SYSTEM in
  Darwin)
    if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
      compinit;
    else
      compinit -C;
    fi
    ;;
  Linux)
    # not yet match GNU & BSD stat
  ;;
esac

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias gs='git status'
#alias deletemerged='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'
alias tidyup='cat /dev/null > log/test.log && cat /dev/null > log/development.log && cat /dev/null > log/newrelic_agent.log && rm -rf tmp/cache/*'
#alias goodcode='git diff origin/master --name-only | xargs bundle exec rubocop -a'
#alias goodcode'git ls-files -m --full-name | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs bundle exec rubocop -A'
# alias goodcode='bundle exec rubocop -a $(g diff --name-only --diff-filter=M)'
alias wantmaster='git checkout master && git pull origin master'
alias empty='find . -type d -empty -delete'
alias cat=bat
alias vim=nvim

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - --no-rehash)"
export RUBOCOP_DAEMON_USE_BUNDLER=true
[ -f ~/.ruby.zsh ] && source ~/.ruby.zsh

# Yarn
export PATH="$HOME/.yarn/bin:$PATH"

# fzf + bat
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS='--height 70% --preview "bat --style=numbers --color=always {}"'
export FZF_ALT_C_OPTS="--preview 'tree -L 2 -C {} | head -200'"

# asdf tool versioning
autoload -U +X bashcompinit && bashcompinit
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# Go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH="$GOBIN:$PATH"

# Rust
source $HOME/.cargo/env

# Python
export PYENV_ROOT=/usr/local/var/pyenv
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH=~/Library/Python/2.7/bin:$PATH
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

if [[ -z "$VIRTUAL_ENV" ]]; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

if [ -z "$PYENV_INITIALIZED" ]; then
  eval "$(pyenv init -)"
  export PYENV_INITIALIZED=1
fi

# Functions
function yaml2js {
  if [ -n "$1" ]; then
    yq -j eval $1
  else
    echo "File please"
  fi
}

function fuckingspring {
  spring stop && pkill -f spring && ps aux | grep spring
}

function goodcode {
  git add -N . && bundle exec rubocop -A $({ git diff HEAD --name-only --diff-filter=AMC & git diff origin/master..HEAD --name-only --diff-filter=AMC; } | sort | uniq | grep "\.rb$" | tr '\n' ' ')
}

function circleToken() {
  yq eval '.token' "$HOME/.circleci/cli.yml"
}

function circleURL() {
  git remote get-url origin | sed -e 's/git@//g' | sed -e 's/\.com//g' | sed -e 's/:/\//g' | sed -e 's/\.git//g'
}

function retry_circle_build() {
  curl -X POST "https://circleci.com/api/v1.1/project/$(circleURL)/$1/retry?circle-token=$(circleToken)" | jq '.status, .build_url' -r
}

function download_circle_artifacts() {
  curl -X GET "https://circleci.com/api/v1.1/project/$(circleURL)/$1/artifacts?circle-token=$(circleToken)"
}

function fetch_failures() {
  curl -X GET "https://circleci.com/api/v1.1/project/$(circleURL)/$1/tests?circle-token=$(circleToken)" | jq '.tests[] | select(.result=="failure") | .file' -r
}

function approve_merge() {
  gh pr review --approve $1 && gh pr merge -m $1 --auto
}

function ggh() {
  git checkout $(git for-each-ref refs/heads/ --format='%(refname:short)' | fzf)
}

function deletemerged() {
  git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Work
[ -f ~/.work.zsh ] && source ~/.work.zsh


export DOCKER_BUILDKIT=1
export GPG_TTY=$(tty)
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"
export GO111MODULE=on
eval "$(op completion zsh)"; compdef _op op
#source /Users/joesouthan/.config/op/plugins.sh

# pnpm
export PNPM_HOME="/Users/joesouthan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
