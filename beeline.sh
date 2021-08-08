#!/bin/bash  


### ------------  BEGIN Functions

function main() {


  # shellcheck disable=SC1090
  source <(/usr/local/bin/kubectl completion zsh)

  [[ -t fd  ]] && export TERMINAL=true
  
  if [ "$TERMINAL" = true  ]; then
  case $SHELL in
   #/bin/zsh )  compdef k='kubectl'; unsetopt complete_aliases;;
   /bin/zsh )   unsetopt complete_aliases;;
   /bin/bash)  complete -F _complete_alias;;
  esac
fi


  if [ $SHLVL = 1 ]; then
    kc "$KS_CONTEXT" "$KS_NAMESPACE"  > /dev/null
  fi


}

function kubectl() { 
  v1=$1;shift
  NO_PROXY="" HTTPS_PROXY="" no_proxy="" https_proxy="" HTTP_PROXY="" http_proxy="" /usr/local/bin/kubectl $v1 --context "$KS_CONTEXT" --namespace "$KS_NAMESPACE" $@
} 

function k() {
  kubectl "$@"
}

function kh() {
  khelp "$@"
}

function kg() {
  kubectl get "$@"
}

function kgp() {
  kubectl get pods "$@"
}

function kgs() {
  kubectl get services "$@"
}

function kd() {
  kubectl describe "$@"
}

function kdp() {
  kubectl describe pod "$@"
}

function kds() {
  kubectl describe service "$@"
}

function kl() {
  kubectl logs "$@"
}

function ke() {
  kubectl edit "$@"
}

function helm() { 
  KUBECONFIG=$(kubeconfig) /usr/local/bin/helm --namespace "$KS_NAMESPACE" --kube-context "$KS_CONTEXT" $@
}

function velero() { 
  KUBECONFIG=$(kubeconfig) /usr/local/bin/velero --kubecontext "$KS_CONTEXT" --namespace "$KS_NAMESPACE"  $@
}

function hs() { 

  
  fc -lim "*${*}*" 1 
}

function kubeconfig() {

  export KUBECONFIG="$(  (ls ~/.kube/*.cfg; ls ~/.kube/config ) | xargs | sed -e "s/ /:/g")"
  echo "$KUBECONFIG"
}

function kc() {
  
  if [ -z "$1" ]; then
    echo ""
    [[ $TERMINAL = true ]] && set -o PROMPT_SUBST
    cyan=$(printf     '\e[0m\e[36m')
    white=$(printf    '\e[0m\e[97m')
    defcolor=$(printf '\e[0m\e[39m')
    wheel=$(printf    '\u2388' )
    export PS1="%{${white}%}[B:%{${cyan}%}$KS_CONTEXT:$KS_NAMESPACE%{${white}%}]%{${defcolor}%} %n:%/$ "

    KS_CLUSTER=$(/usr/local/bin/kubectl get --context "$KS_CONTEXT" cn -o custom-columns=:.spec.clusterName --no-headers=true 2>/dev/null) 
    [[ ! -z "$KS_CLUSTER" ]] && echo "Cluster    : $KS_CLUSTER";
    echo "Context    : $KS_CONTEXT";
    echo "Namespace  : $KS_NAMESPACE";
    echo ""
  else
    export KS_CONTEXT=$1
    if [ -z "$2" ]; then
      kc  ""
    else
      kn "$2"
    fi
  fi

  export KUBECONFIG=$(kubeconfig)
  /usr/local/bin/kubectl  config  view --context $KS_CONTEXT --namespace $KS_NAMESPACE --minify --raw=true -oyaml > $HOME/.kube/beeline.properties.$$
  export KUBECONFIG=$HOME/.kube/beeline.properties.$$
  /usr/local/bin/kubectl config set-context "$KS_CONTEXT" --namespace="$KS_NAMESPACE" 
  /usr/local/bin/kubectl config set current-context "$KS_CONTEXT" 
 

  # reset aliases
  export NP='NO_PROXY="" HTTPS_PROXY="" no_proxy="" https_proxy="" HTTP_PROXY="" http_proxy=""'
  alias kubectl="${NP} /usr/local/bin/kubectl"
  alias k="${NP} kubectl"
  alias kgp="${NP} kubectl get pods"

}

function kn() {
  if [ -n "$1" ]; then
    ### x=`k config current-context`
    export KS_NAMESPACE=${1}
    #/usr/local/bin/kubectl config set-context "$KS_CONTEXT" --namespace="$1"
  fi
  kc ""
}


khelp() {

cat <<EOD
These are the latest shortcuts supported:

k       = kubectl
kubectl = improved kubectl with seperate configs
helm    = improved helm v2 with seperate configs

kh      = this help page
kg      = kubectl get
kgp     = kubectl get pods
kgs     = kubectl get services
kd      = kubectl describe
kdp     = kubectl describe pod
kds     = kubectl describe service
kl      = kubectl logs

EOD

}

trap "rm -f $HOME/.kube/beeline.properties.$$" EXIT

main "$@"
