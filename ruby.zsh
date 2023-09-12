function migrate {
  echo "Dev"
  bin/rails db:migrate
  echo "Test"
  RAILS_ENV=test bin/rails db:migrate
}

function rollback {
  echo "Dev"
  bin/rails db:rollback
  echo "Test"
  RAILS_ENV=test bin/rails db:rollback
}

alias rspec='nocorrect rspec'
alias be="bundle exec"
alias b='bundle'
alias routes='bin/rake routes'
alias rails='bin/rails'
alias rake='bin/rake'
alias rc='bin/rails c'
alias rs='bin/rails s'
alias fuckingrspec='bin/rake db:drop RAILS_ENV=test && bin/rake db:create RAILS_ENV=test && bin/rake db:schema:load RAILS_ENV=test && spring stop'
alias schemapls='g checkout -- db/schema.rb'
alias dbreset='g checkout -- db/structure.sql && bin/rails db:reset'

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1) --with-jemalloc --enable-yjit"
