# Zsh configuration for interactive shells.
# Login shells also read this (after ~/.zprofile).

test -s ~/.alias && . ~/.alias || true # Load them aliases

export ERL_AFLAGS="-kernel shell_history enabled" # Enable IEx Shell History
export PATH="$HOME/.claudepod:$PATH"              # Podman based Claude Code sandboxing

setopt IGNORE_EOF # DO NOT EXIT ON CTRL+D

# Completion system + bash-completion shim (so the OCI script below works in zsh)
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

eval "$(starship init zsh)" # Starship prompt
eval "$(mise activate zsh)" # Mise-en-place

export PATH="$HOME/.local/bin:$PATH"

[[ -e "$HOME/.local/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "$HOME/.local/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh"
alias oci='PYTHONWARNINGS="ignore::FutureWarning" oci'
export PATH="$HOME/.npm-global/bin:$PATH"
