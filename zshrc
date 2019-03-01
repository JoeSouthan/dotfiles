# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

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
alias goodcode='git diff origin/master --name-only | xargs bundle exec rubocop'
alias wantmaster='git checkout master && git pull origin master'
alias empty='find . -type d -empty -delete'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH=~/Library/Python/2.7/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export PATH="$HOME/.yarn/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

export PATH="/usr/local/opt/python/libexec/bin:$PATH"
