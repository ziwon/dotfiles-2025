# Example machine-local zsh configuration.
# Copy selected snippets into ~/.zshrc.local or ~/.zshrc.work.

# LM Studio CLI
if [[ -d "$HOME/.lmstudio/lisbin" ]]; then
    export PATH="$PATH:$HOME/.lmstudio/lisbin"
fi
if [[ -d "$HOME/.lmstudio/bin" ]]; then
    export PATH="$PATH:$HOME/.lmstudio/bin"
fi

# OpenCode / OpenFang
if [[ -d "$HOME/.opencode/bin" ]]; then
    export PATH="$HOME/.opencode/bin:$PATH"
fi
if [[ -d "$HOME/.openfang/bin" ]]; then
    export PATH="$HOME/.openfang/bin:$PATH"
fi

# Google Cloud SDK
if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# Granted / AWS profile helper
assume() {
    export DEFAULT_BROWSER_PROFILE="${DEFAULT_BROWSER_PROFILE:-Work}"
    export GRANTED_ALIAS_CONFIGURED="true"

    if [[ " $* " =~ " -s " ]] || [[ " $* " =~ " -c " ]]; then
        command assume "$@" --browser-profile "$DEFAULT_BROWSER_PROFILE"
    else
        command assume "$@"
    fi
}

aws-profile() {
    (( $+commands[aws] )) || return 1
    (( $+commands[fzf] )) || return 1
    (( $+commands[assume] )) || return 1

    export AWS_PROFILE
    AWS_PROFILE="$(aws configure list-profiles | fzf --prompt "Choose active AWS profile:")"
    [[ -n "$AWS_PROFILE" ]] && assume "$AWS_PROFILE"
}
