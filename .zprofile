
export PATH="/Users/liottar/Library/Python/3.8/bin:/usr/local/bin:${PATH}"
eval $(/opt/homebrew/bin/brew shellenv)

FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

function gt() {
  TAG=${1}; git tag --delete ${TAG} 2>/dev/null; git push  --delete origin ${TAG} 2>/dev/null; git tag  ${TAG}; git push --tags
}

autoload -Uz compinit
compinit 2>/dev/null

source <(kubectl completion zsh)
mkdir ~/.kube 2>/dev/null 
[[ ! -f ~/.k8s_shortcuts ]]  \
&& curl -s -L https://github.com/BobDotMe/k8s_shortcuts/releases/latest/download/k8s_shortcuts  > ~/.k8s_shortcuts
source ~/.k8s_shortcuts

true;
