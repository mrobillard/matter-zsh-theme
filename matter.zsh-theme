# vim: filetype=sh

###############################################################################
## Matter ZSH Theme
##
## Matt Robillard (c) 2019 
############################################################################### 

# Prompt symbol
COMMON_PROMPT_SYMBOL="❯"

# Prompt
PROMPT='%B$(common_host)$(common_current_dir)$(common_bg_jobs)%b$(common_git_status)%B$(common_return_status)%b'

#------------------------------------------------------------------------------
# Host
#------------------------------------------------------------------------------
common_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[green]%}$me%{$reset_color%}:"
  fi
  if [[ $AWS_VAULT ]]; then
    echo "%{$fg[yellow]%}$AWS_VAULT%{$reset_color%} "
  fi
}

#------------------------------------------------------------------------------
# Current directory
#------------------------------------------------------------------------------
common_current_dir() {
  echo -n "%{$fg[cyan]%}%c "
}

#------------------------------------------------------------------------------
# Prompt symbol
#------------------------------------------------------------------------------
common_return_status() {
  echo -n "%(?.%F{green}.%F{red})$COMMON_PROMPT_SYMBOL%f "
}

#------------------------------------------------------------------------------
# Git status
#------------------------------------------------------------------------------
common_git_status() {
    local message=""
    local message_color="%F{green}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{red}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{yellow}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}%B(${branch})%b%f "
    fi

    echo -n "${message}"
}

# Git prompt SHA
# ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{%F{green}%}"
# ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%} "

#------------------------------------------------------------------------------
# Background Jobs
#------------------------------------------------------------------------------
common_bg_jobs() {
  bg_status="%{$fg[yellow]%}%(1j.↓%j .)"
  echo -n $bg_status
}
