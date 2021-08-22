#!/bin/bash      
### ^^^ Needed for Shellcheck.  Not intended to run this as a script.  It must be sourced.

### Main Function - Setup goes here
function main() {

  # shellcheck disable=SC1090
  source <(/usr/local/bin/kubectl completion zsh)

  [[ -t fd  ]] && export TERMINAL=true  # Check if this is an interactive session
  
  if [ "$TERMINAL" = true ]; then
    case $SHELL in
      /bin/zsh )   unsetopt complete_aliases;;
      /bin/bash)  complete -F _complete_alias;;
    esac
  fi

  # set the default context and namespace from the .zshrc file
  if [ $SHLVL = 1 ] || [ "$TERM_PROGRAM" = "vscode" ]; then
  kc >/dev/null
  fi

}

### Functions to match aliases -  These are used for the shell scripts and the aliases are needed to autocompletion

function kubectl()      { NO_PROXY="" HTTPS_PROXY="" no_proxy="" https_proxy="" HTTP_PROXY="" http_proxy="" /usr/local/bin/kubectl "$@"; } 
function k()            { kubectl "$@"; }
function kd()           { kubectl describe "$@"; }
function kdp()          { kubectl describe pod "$@";}
function kds()          { kubectl describe service "$@"; }
function ke()           { kubectl edit "$@";}
function kh()           { khelp "$@"; }
function kg()           { kubectl get "$@"; }
function kgp()          { kubectl get pods "$@";}
function kgs()          { kubectl get services "$@"; }
function kl()           { kubectl logs "$@"; }

### Other miscellaneous aliases
function helm()         { /usr/local/bin/helm "$@"; }
function hs()           { fc -lim "*${*}*" 1; }
function kn()           { if [ -n "$1" ]; then export KS_NAMESPACE=${1}; fi; kc ""; }
function kubeconfig()   {   export KUBECONFIG; KUBECONFIG="$(  (ls ~/.kube/*.cfg; ls ~/.kube/config ) | xargs | sed -e "s/ /:/g")"; echo "$KUBECONFIG"; }
function velero()       { /usr/local/bin/velero "$@"; }

function kc() {
  
  if [ -z "$1" ]; then
    echo ""
    [[ $TERMINAL = true ]] && set -o PROMPT_SUBST
    cyan=$(printf     '\e[0m\e[36m')
    white=$(printf    '\e[0m\e[97m')
    defcolor=$(printf '\e[0m\e[39m')
    export PS1="%{${white}%}[B:%{${cyan}%}$KS_CONTEXT:$KS_NAMESPACE%{${white}%}]%{${defcolor}%} %n:%/$ "
    KS_CLUSTER=$(/usr/local/bin/kubectl get --context "$KS_CONTEXT" cn -o custom-columns=:.spec.clusterName --no-headers=true 2>/dev/null) 
    [[ ! -z "$KS_CLUSTER" ]] && echo "Cluster    : $KS_CLUSTER";
    #[[ -n "$KS_CLUSTER" ]] && echo "Cluster    : $KS_CLUSTER";
    echo "Context    : $KS_CONTEXT";
    echo "Namespace  : $KS_NAMESPACE";
    echo ""
  else
    export KS_CONTEXT=$1
    if [ -z "$2" ]; then kc  "" else kn "$2"; fi
  fi

  export KUBECONFIG; KUBECONFIG=$(kubeconfig)
  /usr/local/bin/kubectl config view --context "$KS_CONTEXT" --namespace "$KS_NAMESPACE" --minify --raw=true -oyaml > "$HOME/.kube/beeline.properties.$$"
  
  export KUBECONFIG; KUBECONFIG="$HOME/.kube/beeline.properties.$$"
  /usr/local/bin/kubectl config set-context "$KS_CONTEXT" --namespace="$KS_NAMESPACE" 
  /usr/local/bin/kubectl config set current-context "$KS_CONTEXT" 
 

  # reset aliases

  alias kubectl="NO_PROXY='' HTTPS_PROXY='' no_proxy='' https_proxy='' HTTP_PROXY='' http_proxy='' /usr/local/bin/kubectl"
  alias k="kubectl"
  alias kd="kubectl describe"
  alias kdp="kubectl describe pod"
  alias kds="kubectl describe service"
  alias ke="kubectl edit"
  alias kh="khelp"
  alias kg="kubectl get"
  alias kgp="kubectl get pods"
  alias kgs="kubectl get services"
  alias kl="kubectl logs"

  ### Other miscellaneous aliases
  alias helm="/usr/local/bin/helm"
  alias velero="/usr/local/bin/velero"

}

khelp() {

cat <<EOD
  These are the latest shortcuts supported:

  kubectl = improved kubectl with seperate configs
  k       = kubectl
  kd      = kubectl describe
  kdp     = kubectl describe pod
  kds     = kubectl describe service
  ke      = kubectl edit
  kh      = this help page
  kg      = kubectl get
  kgp     = kubectl get pods
  kgs     = kubectl get services
  kl      = kubectl logs

  helm    = improved helm v3 with seperate configs
  velero  = improved velero with seperate configs

EOD

}

function kf () {

O=$1
shift
F=$*

k get "${O}" | grep -E "NAME|$F" 
}

function kfl () {

kf $* | awk '{print $1}' | grep -v 'NAME' | xargs
}

#########################  MAIN Script starts here ###############################

# shellcheck disable=SC2064
trap "rm -f ${HOME}/.kube/beeline.properties.${$}" EXIT
main "$@"
