#!/bin/bash      
### ^^^ Needed for Shellcheck.  Not intended to run this as a script.  It must be sourced.


### Main Function - Setup goes here
function main() {

  [[ -t fd  ]] && export TERMINAL=true  # Check if this is an interactive session
  
  if [ "$TERMINAL" = true ] && [ $SHLVL = 1 ]; then
    case $SHELL in
      /bin/zsh )   unsetopt complete_aliases; export KS_SHELL=zsh;;
      /bin/bash)  complete -F _complete_alias; export KS_SHELL=bash;;
    esac
  fi

  # shellcheck disable=SC1090
  source <(/usr/local/bin/kubectl completion "$KS_SHELL")


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
function kn()           { if [ -n "$1" ]; then export KS_NAMESPACE=${1}; fi; kc ""; }
function kv()           { kubectl version; grep "# Version: " "${HOME}/beeline.k8s" }

### Utility Functions

function kfl()          { [[ "$#" -gt 1 ]] && { kf "$@" | awk '{print $1}' | grep -v 'NAME' | xargs; } || echo "kfl requires exactly 2 parameters"; }
function kf()           { [[ "$#" -gt 1 ]] && { O=$1; shift; F="${*}"; k get "${O}" | grep -E "NAME|$F"; } || echo "kf requires exactly 2 parameters"; }

### Other miscellaneous aliases
function helm()         { /usr/local/bin/helm "$@"; }
function hs()           { fc -lim "*${*}*" 1; }
function kubeconfig()   {   export KUBECONFIG; KUBECONFIG="$(  (ls ~/.kube/*.cfg; ls ~/.kube/config ) | xargs | sed -e "s/ /:/g")"; echo "$KUBECONFIG"; }
function velero()       { /usr/local/bin/velero "$@"; }

function kc() {
  
  if [ -z "${1}" ]; then
    echo ""
    [[ $TERMINAL = true ]] && [ $SHLVL = 1 ] && set -o PROMPT_SUBST
    cyan=$(printf     '\e[0m\e[36m')
    white=$(printf    '\e[0m\e[97m')
    defcolor=$(printf '\e[0m\e[39m')
    export PS1="%{${white}%}[B:%{${cyan}%}$KS_CONTEXT:$KS_NAMESPACE%{${white}%}]%{${defcolor}%} %n:%/$ "
    KS_CLUSTER=$(/usr/local/bin/kubectl get --context "$KS_CONTEXT" cn -o custom-columns=:.spec.clusterName --no-headers=true 2>/dev/null) 
    [[ -n "$KS_CLUSTER" ]] && echo "Cluster    : $KS_CLUSTER";
    echo "Context    : $KS_CONTEXT";
    echo "Namespace  : $KS_NAMESPACE";
    echo ""
    echo ""
  else
    export KS_CONTEXT=${1}
    if [ -z "${2}" ]; then kc ""; else kn "${2}"; fi
  fi


  export KUBECONFIG; KUBECONFIG=$(kubeconfig)
  /usr/local/bin/kubectl config view --context "$KS_CONTEXT" --namespace "$KS_NAMESPACE" --minify --raw=true -oyaml > "$HOME/.kube/beeline.properties.$$" \
    && chmod 700 "$HOME/.kube/beeline.properties.$$"
  
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


  if [ -z "${2}" ]; then 
    echo ""
    /usr/local/bin/kubectl get --context "$KS_CONTEXT" nodes -o custom-columns='NAME:.metadata.name,STATUS:.status.conditions[?(@.reason=="KubeletReady")].type,ARCH:.status.nodeInfo.architecture,INTERNAL ADDRESS:status.addresses[?(@.type=="InternalIP")].address,KERNEL:.status.nodeInfo.kernelVersion,VERSION:.status.nodeInfo.kubeletVersion,OS:.status.nodeInfo.osImage,CONTAINER RUNTIME:.status.nodeInfo.containerRuntimeVersion' | colorize
  fi

}

khelp() {

cat <<EOD
  beeline - Version: v2.2.0-RC1

  These are the latest shortcuts supported.  You will find autocomplete works on all.

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
  kv      = kubectl & beeline version

  helm    = improved helm v3 with seperate configs
  velero  = improved velero with seperate configs

  Special utility functions:

  kf      = kubectl find.  This will the current context and filter the list.  You can use a '|' character to concatenate 
            more than one filter.  Example:  Assuming the cluster is set and the namespace is kube-system *kf pod "coredns|calico" 
            will return all pods that include those strings.
  kfl     = Same as *kf* but will return a list appropriate to include as a list in a kubectl command
            Example:  *kgp $(kfl service "coredns|calico")* will return a filtered list of pods.  This can be used with all shortcuts.

EOD

}

function checks() {

  let bok=0
  [[ ! -f ${ok_file} ]] \
     && { echo "Beeline - pre launch check... \n";
          [[ -z "${ZSH_VERSION}" ]] \
             && { echo -n "beeline not installed.  "
                  echo "Please install. Refer to "https://github.com/262life/beeline" for help" 
                  let bok+=1
                }
          [[ ! -x "/usr/local/bin/helm" ]] \
             && { echo -n "helm not installed.  "
                  echo "Please install in /usr/local/bin. Refer to "https://helm.sh/docs/intro/install/" for help"
                  let bok+=1  
                }
          [[ ! -x "/usr/local/bin/kubectl" ]] \
             && { echo -n "kubectl not installed.  "
                  echo "Please install in /usr/local/bin. Refer to "https://kubernetes.io/docs/tasks/tools/#kubectl" for help" 
                  let bok+=1 
                }
        }  
  [[ $bok -eq 0 ]] \
     && { touch ${ok_file}
          return 0
        } || return $bok

}

function colorize() {
  awk '
  function color(c,s) {
           printf("\033[%dm%s\033[0m\n",30+c,s)
  }
  /amd64/ {color(7,$0);next}
  /arm64/ {color(5,$0);next}
  {print}
  '   #### $1

}

check_for_update() {

  if [[ $(find ${ok_file} -mtime +${days} 2>/dev/null) = "$ok_file" ]]; then
    candidate=$(curl -s -L https://github.com/262life/beeline/releases/${release}/checksum.sha512)
    current=$(cat ~/.beeline.k8s | shasum -a 512)
    if [[ "$candidate" != "$current" ]] ; then

      # Ask for confirmation and only update on 'y', 'Y' or Enter
      # Otherwise just show a reminder for how to update
      echo -n "${cyan}[beeline] Would you like to update? ${white}[${cyan}Y/n${white}]${defcolor} "
      read -r -k 1 option
      [[ "$option" = $'\n' ]] || echo
      case "$option" in
        [yY$'\n']) update_beeline ;;
        [nN]) update_last_updated_file ;&
        *) echo "[beeline] You can update manually by ........" ;;
      esac
    fi
  fi

}

update_last_updated_file() {

  touch  ${ok_file}

}

update_beeline() {

  echo  "${cyan}Updating...${defcolor} "
  curl -s -L https://github.com/262life/beeline/releases/${release}/beeline.sh > "${HOME}/.beeline.k8s"
  update_last_updated_file
  exec $0

}


#########################  MAIN Script starts here ###############################

# Version: v2.2.0-RC1

release="latest/download"  #<-- to test: release="download/v2.2.0-RC1"
ok_file="${HOME}/.beeline.ok"
days=7


# shellcheck disable=SC2064
trap "rm -f ${HOME}/.kube/beeline.properties.${$}" EXIT
check_for_update
checks && main "$@"
