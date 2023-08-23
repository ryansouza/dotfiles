#export EDITOR='mvim -f -nomru -c "au VimLeave * !open -a Terminal"'
export EDITOR='mvim -v'
export VISUAL='mvim -f'

export CLICOLOR='Yes'
export LSCOLORS='gxBxhxDxfxhxhxhxhxcxcx'

export HISTCONTROL=ignoredups

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH="/usr/local/opt/openssl/bin:$PATH"
export MANPATH=/usr/local/share/man:$MANPATH

# Paths for node
export PATH=/usr/local/share/npm/bin:$PATH

export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# Custom bash prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=''
#export GIT_PS1_SHOWUPSTREAM="auto verbose"
export PS1='\n[$? \h:\w$(__git_ps1 " (%s)")]\n$ '

# homebrew bash completion
. "/usr/local/etc/profile.d/bash_completion.sh"

# Add rbenv for managing ruby versions
eval "$(rbenv init -)"

# ruby-build use homebrew openssl
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"


alias b='bundle'
alias be='bundle exec'
alias va='vagrant'
alias vp='vagrant provision'
alias hack='git fetch origin $(git default-branch):$(git default-branch) && git rebase $(git default-branch) $@'
alias gc="git commit -m"
alias gca="git commit --amend"
alias gcane="git commit --amend --no-edit"
alias marked="open -a Marked"
alias diff="diff -u"
alias bat='/usr/local/bin/bat --theme $(bat-theme)'
alias k=kubectl

function json {
  jq . | bat -l json
}

function rmb {
  current_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [ "$current_branch" != "master" ]; then
    echo "WARNING: You are on branch $current_branch, NOT master."
  fi
    echo "Fetching merged branches..."
  git remote prune origin
  remote_branches=$(git branch -r --merged | grep -v '/master$' | grep -v "/$current_branch$")
  local_branches=$(git branch --merged | grep -v 'master$' | grep -v "$current_branch$")
  if [ -z "$remote_branches" ] && [ -z "$local_branches" ]; then
    echo "No existing branches have been merged into $current_branch."
  else
    echo "This will remove the following branches:"
    if [ -n "$remote_branches" ]; then
      echo "$remote_branches"
    fi
    if [ -n "$local_branches" ]; then
      echo "$local_branches"
    fi
    read -p "Continue? (y/n): " -n 1 choice
    echo
    if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
      # Remove remote branches
      git push origin `git branch -r --merged | grep -v '/master$' | grep -v "/$current_branch$" | sed 's/origin\//:/g' | tr -d '\n'`
      # Remove local branches
      git branch -d `git branch --merged | grep -v 'master$' | grep -v "$current_branch$" | sed 's/origin\///g' | tr -d '\n'`
    else
      echo "No branches removed."
    fi
  fi
}

function git-release() {
    git fetch origin -q
    local current_release_number=$(git tag -l 'v*' | sed -E 's/^v//g' | sort -g | tail -n 1)
    local current_release="v$current_release_number"
    echo "Current release: $current_release"
    local next_release=v$(( $current_release_number + 1 ))
    echo "Releasing: $next_release"
    git tag $next_release && git push origin $next_release
    echo 'deploy with: '
    echo "REVISION=$next_release bundle exec cap production deploy"
    echo 'github diff:'
    local project="${PWD##*/}"
    echo "https://github.com/fastly/$project/compare/$current_release...$next_release"
}

ulimit -Sn 4096
ulimit -u 2048

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# Google Cloud SDK
source /Users/rsouza/google-cloud-sdk/completion.bash.inc
source /Users/rsouza/google-cloud-sdk/path.bash.inc

export GOPATH="$HOME/p/gopath"
export PATH="$GOPATH/bin:$PATH"

export BASTION_HOST='bastion'

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/rsouza/google-cloud-sdk/path.bash.inc' ]; then . '/Users/rsouza/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/rsouza/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/rsouza/google-cloud-sdk/completion.bash.inc'; fi

# krew PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# k8s login
export INFRA_SERVER=infra.plat.k8s.secretcdn.net
export INFRA_PROVIDER=okta

. <(flux completion bash)
. <(kubectl completion bash)
