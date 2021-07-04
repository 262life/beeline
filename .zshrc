###  Setup auto-completion
ZSH_DISABLE_COMPFIX=true
autoload -Uz compinit 
compinit
fpath=(/usr/local/share/zsh-completions $fpath)

#####  Setup Beeline

## Defaults if you like
export KS_CONTEXT='avengers'
export KS_NAMESPACE='kube-system'

[[ ! -f ~/.beeline.k8s ]]  \
&& cp ~/projects/262life/k8s_shortcuts/beeline.k8s ~/.beeline.k8s   #curl -s -L https://github.com/BobDotMe/k8s_shortcuts/releases/latest/download/k8s_shortcuts  > ~/.k8s_shortcuts

source ~/.beeline.k8s
##### End of Beeline

export GOPATH=$HOME/go
export GOROOT=$(go env GOROOT)  
GOPROXY=https://proxy.golang.org,direct

export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/liottar/go/bin:/users/liottar/bin

. /usr/local/bin/proxy.env

ulimit -n 8096

alias flush_dns='sudo killall -HUP mDNSResponder;sudo dscacheutil -flushcache'
alias srecord='asciinema'
alias sp='bbedit --scratchpad --launch'

function gt() {
  TAG=${1}; git tag --delete ${TAG} 2>/dev/null; git push  --delete origin ${TAG} 2>/dev/null; git tag  ${TAG}; git push --tags
}


