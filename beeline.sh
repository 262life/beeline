#!/bin/bash 

### ------------  BEGIN Functions

function main() {

  # shellcheck disable=SC1090
  source <(/usr/local/bin/kubectl completion zsh)

  compdef k='kubectl'
  setopt complete_aliases

  #  Bash Version ####  complete -F _complete_alias k


  if [ $SHLVL = 1 ]; then
    kc "" >/dev/null
  fi

}

function kubectl() { 
  v1=$1;shift
  NO_PROXY="" HTTPS_PROXY="" no_proxy="" https_proxy="" KUBECONFIG=$(kubeconfig) HTTP_PROXY="" http_proxy="" /usr/local/bin/kubectl $v1 --context "$KS_CONTEXT" --namespace "$KS_NAMESPACE" $@
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

  KUBECONFIG="$(  (ls ~/.kube/*.cfg; ls ~/.kube/config ) | xargs | sed -e "s/ /:/g")"

  echo "$KUBECONFIG"
}

function kc() {
  
  if [ -z "$1" ]; then
    echo ""
    k --context "$KS_CONTEXT" -n kube-system get configmap kubeadm-config -o json 2>/dev/null | jq '. | .data | .ClusterConfiguration ' | sed -e 's/.*clusterName/ClusterName/g' -e 's/\\n.*//g' -e 's/ //'
    #k config get-contexts | grep '*' | awk '{print "Context    :  " $2 "\n" "Namespace  :  " $5}
    #vars=$(k config get-contexts | grep '*' | awk '{print "export KS_CONTEXT=" $2  ";export KS_NAMESPACE=" $5}')
    #eval $vars;
    #autoload -Uz compinit
    #compinit 2>/dev/null
    set -o PROMPT_SUBST
    cyan=$(printf     '\e[0m\e[36m')
    white=$(printf    '\e[0m\e[97m')
    defcolor=$(printf '\e[0m\e[39m')
    wheel=$(printf    '\u2388' )
    export PS1="%{${white}%}[%{${wheel}%}:%{${cyan}%}$KS_CONTEXT:$KS_NAMESPACE%{${white}%}]%{${defcolor}%} %n:%/$ "
    echo "Context    :$KS_CONTEXT";
    echo "Namespace  :$KS_NAMESPACE";
    echo ""
  else
    export KS_CONTEXT=$1
    /usr/local/bin/kubectl config unset current-context 
    if [ -z "$2" ]; then
      kc  ""
    else
      kn "$2"
    fi
  fi
}

function kn() {
  if [ -n "$1" ]; then
    x=`k config current-context`
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

main "$@"
