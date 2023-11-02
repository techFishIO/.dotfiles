# shellcheck shell=bash disable=SC1090,SC1091  # ignore refusal to follow dynamic paths

# Load logger or overload with no-op
if [[ ${DEBUG:-} -eq 1 ]]; then
    set +ua
    source "${HOME}/.dotfiles/lib/log.sh"
    set -ua
    log debug ""
    log debug "[${BASH_SOURCE[0]}]"
else
    log_sh_args=( "info" "warn" "error" "debug" )
    function log() {
        if [[ "${log_sh_args[*]}" =~ ${1:-} ]]; then
            true
        else
            log "$@"
        fi
    }
fi

# -a: Export all functions to make them available in sub-shells
# -u: We should not use unbound variables
# -o pipefile: We should ensure pipelines fail if commands within them fail
#
# WARNING: Unset with +a and +u before sourcing third party libraries or they
# will export functions and throw errors
set -uao pipefail

# Make my bins available while loading dotfiles
export PATH="${HOME}/.dotfiles/bin:${PATH}"

# Globals
if [[ $(uname -m) == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
else
    BREW_PREFIX="/usr/local"
fi

# Put brew bins first in path
export PATH="${BREW_PREFIX}/bin:${PATH}"

export DOTFILES_PREFIX="${HOME}/.dotfiles"
export BASH_D_PATH="${DOTFILES_PREFIX}/bash.d"

# Use my ncurses and terminfo
export PATH="${BREW_PREFIX}/opt/ncurses/bin:$PATH"
export TERMINFO=~/.local/share/terminfo
export TERMINFO_DIRS=~/.local/share/terminfo

# History
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:ignorespace # don't put duplicate lines in the history

shopt -s histappend # append
shopt -s checkwinsize # check the win size after each command and update if necessary
history -a # append
history -n # read new lines and append

# Use vi mode on command line
set -o vi
bind '"jj":vi-movement-mode'

# Disable flow control commands (keeps C-s from freezing everything)
stty -ixon 2> /dev/null

# Load everything else
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

source "${BASH_D_PATH}/lib.sh"
source "${BASH_D_PATH}/path.sh"
source "${BASH_D_PATH}/bash.sh"

# +u: Allow unbound variables
# +a: Don't export functions to sub-sells
set +ua

log debug "[$(basename "${BASH_SOURCE[0]}")]: Done, .bash_profile loaded."

# vi: ft=sh
