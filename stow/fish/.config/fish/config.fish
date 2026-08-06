if status is-interactive
    alias ll="eza -l --icons --git"
end
set PATH /opt/homebrew/bin $PATH
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Google Cloud SDK.
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.fish.inc' ]; . '/opt/homebrew/share/google-cloud-sdk/path.fish.inc'; end

# goenv
set -x GOENV_ROOT $HOME/.goenv
set -x PATH $GOENV_ROOT/bin $PATH
status --is-interactive; and source (goenv init -|psub)
