<img alt="bob" align="left" src="K8-Beeline.png" width="20%" height="20%">

## beeline.k8s - A library of Kubernetes Shortcuts

This is a collection of kubectl and bash/zsh shortcuts to make interactions with Kubernetes a bit easier.

![Hex.pm](https://img.shields.io/hexpm/l/apa)
[![CodeFactor](https://www.codefactor.io/repository/github/262life/beeline/badge)](https://www.codefactor.io/repository/github/262life/beeline)
![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/262life/beeline/release/v2.0.0-RC1?label=build%20v2.0.0-RC1)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/262life/beeline)
![Twitter Follow](https://img.shields.io/twitter/follow/262life?style=social)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/262life/beeline)

beeline.k8s integrates into your bash or zsh shell to provide a number of useful shortcuts as well as the ability to keep individual kubectl config files for each cluster.  The makes mangaging the configs much easier to read and manage in the end.

For more details about the solutions currently supported by beeline.k8s, please refer to the [project status section](#project-status) below.
We plan to continue adding support for many common functions required based on community demand and engagement in future releases. 

## Getting Started and Documentation

To use the scripts it is *recommended* that you have setup either bash or zsh completion in advance.
Once enabled, you can also enable kubectl's auto completion as well.

To enable these shortcuts you must source them into your shell.  This is dependent on the shell you are using.

You can either download the desired version you would like or if you are lazy like me do something like this if you use zsh:

```
###  Setup auto-completion
eval $(/opt/homebrew/bin/brew shellenv)
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

ZSH_DISABLE_COMPFIX=true
autoload -Uz compinit 
compinit 2>/dev/null

#####  Setup Beeline

## Defaults if you like
export KS_CONTEXT='cities'
export KS_NAMESPACE='kube-system'

[[ ! -f ~/.beeline.k8s ]]  \
&& curl -s -L https://github.com/262life/beeline/releases/latest/download/beeline.sh  > ~/.beeline.k8s

source ~/.beeline.k8s
##### End of Beeline
```
Restart your shell and you should be good to go!  Now, review the [documentation](DOCUMENTATION.md) 

## Contributing

We welcome contributions. 

## Report a Bug

For filing bugs, suggesting improvements, or requesting new features, please open an [issue](https://github.com/262life/beeline.k8s/issues).

## Contact

Please use the following to reach members of the community:

- Email: [support@262.life](mailto:support@262.life)

## Security

### Reporting Security Vulnerabilities

If you find a vulnerability or a potential vulnerability in Rook please let us know immediately at
[support@262.life](mailto:support@262.life). We'll send a confirmation email to acknowledge your
report, and we'll send an additional email when we've identified the issues positively or
negatively.


## Project Status

We consider the latest release to be **stable**.  If you use a release candidate proceed with caution. 


### Official Releases

Official releases of beeline.k8s can be found on the [releases page](https://github.com/262life/beeline/releases).
Please note that it is **strongly recommended** that you use [official releases](https://github.com/262life/beeline/releases) of beeline.k8s, as unreleased versions from the master branch are subject to changes and incompatibilities that will not be supported in the official releases.
Builds from the master branch can have functionality changed and even removed at any time without compatibility support and without prior notice.

## Licensing

beeline.k8s is under the Apache 2.0 [License.](LICENSE)




