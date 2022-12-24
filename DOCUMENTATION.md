# beeline.k8s - Documentation

  beeline - Version: v2.2.5

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
  ku      = force an update check for beeline
  kv      = kubectl & beeline version

  helm    = improved helm v3 with seperate configs
  velero  = improved velero with seperate configs

  Special utility functions:

  kf      = kubectl find.  This will the current context and filter the list.  You can use a '|' character to concatenate 
            more than one filter.  Example:  Assuming the cluster is set and the namespace is kube-system *kf pod "coredns|calico" 
            will return all pods that include those strings.
  kfl     = Same as *kf* but will return a list appropriate to include as a list in a kubectl command
            Example:  *kgp $(kfl service "coredns|calico")* will return a filtered list of pods.  This can be used with all shortcuts.

