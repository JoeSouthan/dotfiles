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
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

function _migrate_rails {
  if [ -n "`bundle show rails | grep 'rails\-5'`" ]; then
    runner='bin/rails'
  else
    runner='bin/rake'
  fi

  if [ -e 'db/structure.sql' ]; then
    $runner db:migrate && $runner db:migrate RAILS_ENV=test
  else
    $runner db:migrate && $runner db:schema:load RAILS_ENV=test
  fi
}

alias rspec='nocorrect rspec'
alias be="bundle exec"
alias b='bundle'
alias routes='bin/rake routes'
alias migrate='_migrate_rails'
alias rollback='bin/rake db:rollback'
alias gs='git status'
alias rails='bin/rails'
alias rake='bin/rake'
alias rc='bin/rails c'
alias fuckingrspec='bin/rake db:drop RAILS_ENV=test && bin/rake db:create RAILS_ENV=test && bin/rake db:schema:load RAILS_ENV=test && spring stop'
alias schemapls='g checkout -- db/schema.rb'
alias deletemerged='git branch --merged master | grep -v "\master" | xargs -n 1 git branch -d'
alias tidyup='cat /dev/null > log/test.log && cat /dev/null > log/development.log && cat /dev/null > log/newrelic_agent.log && rm -rf tmp/cache/*'
#alias goodcode='git diff origin/master --name-only | xargs bundle exec rubocop -a'
#alias goodcode'git ls-files -m --full-name | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs bundle exec rubocop -A'
# alias goodcode='bundle exec rubocop -a $(g diff --name-only --diff-filter=M)'
alias wantmaster='git checkout master && git pull origin master'
alias empty='find . -type d -empty -delete'
alias _yaml2js="python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export RUBOCOP_DAEMON_USE_BUNDLER=true

# Yarn
export PATH="$HOME/.yarn/bin:$PATH"

# fzf + bat
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS='--height 70% --preview "bat --style=numbers --color=always {}"'

# asdf tool versioning
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
    cat $1 | _yaml2js
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

function retry_circle_build() {
  local circleURL="$(git remote get-url origin | sed -e 's/git@//g' | sed -e 's/\.com//g' | sed -e 's/:/\//g' | sed -e 's/\.git//g')"
  local circleToken="$(yq r "$HOME/.circleci/cli.yml" 'token')"
  curl -X POST "https://circleci.com/api/v1.1/project/${circleURL}/$1/retry?circle-token=${circleToken}"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Work
[ -f ~/.work.zsh ] && source ~/.work.zsh
