ZSH_DISABLE_COMPFIX=true
autoload -Uz compinit 
compinit


fpath=(/usr/local/share/zsh-completions $fpath)
source <(kubectl completion zsh)
export KUBECONFIG=~/.kube/inc-fed.cfg:~/.kube/config
. /Users/liottar/.k8s_shortcuts


set -o PROMPT_SUBST
cyan=$(printf   '\e[0m\e[36m')
green=$(printf ' \e[0m\e[32m')
export PS1="[K8s: $(echo \$KS_CONTEXT:\$KS_NAMESPACE)] %n:%/$ "

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





