# homebrew.sh
log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# ------------------------------------------------
#  config
# ------------------------------------------------
export HOMEBREW_GITHUB_API_TOKEN="${SECRET_HOMEBREW_GITHUB_PAT}"

# ------------------------------------------------
#  aliases
# ------------------------------------------------
# Avoid linking against any shims
NO_SHIMS_PATH=$(printf "%s" "${PATH}" | sed -e 's,.*shims[^:]*:,,g')
alias brew='env PATH=${NO_SHIMS_PATH} HOMEBREW_NO_AUTO_UPDATE=1 brew'
