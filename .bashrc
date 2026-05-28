# Sample .bashrc for SUSE Linux
# Copyright (c) SUSE Software Solutions Germany GmbH

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

test -s ~/.alias && . ~/.alias || true # Load them aliases

export ERL_AFLAGS="-kernel shell_history enabled" # Enable IEx Shell History
export PATH="$HOME/.claudepod:$PATH"              # Podman based Claude Code sandboxing

set -o ignoreeof # DO NOT EXIT ON CTRL+D

eval "$(starship init bash)" # Starship prompt
eval "$(mise activate bash)" # Mise-en-place

export PATH="$HOME/.local/bin:$PATH"

[[ -e "$HOME/.local/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "$HOME/.local/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh"
alias oci='PYTHONWARNINGS="ignore::FutureWarning" oci'
export PATH="$HOME/.npm-global/bin:$PATH"
