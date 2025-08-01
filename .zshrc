# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/melatonia/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt extended_history   # Record timestamp of command in HISTFILE
setopt hist_ignore_dups   # Ignore duplicated commands history list

# "Command not found" pacman handler
function command_not_found_handler {
  local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
  printf 'zsh: command not found: %s\n' "$1"
  local entries=(
    ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
  )
  if (( ${#entries[@]} ))
  then
    printf "${bright}$1${reset} may be found in the following packages:\n"
    local pkg
    for entry in "${entries[@]}"
    do
      # (repo package version file)
      local fields=(
         ${(0)entry}
      )
      if [[ "$pkg" != "${fields[2]}" ]]
      then
          printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
      fi
      printf '    /%s\n' "${fields[4]}"
      pkg="${fields[2]}"
    done
  fi
  return 127
}

## "Command not found" handler end

# Fish like syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Prompt customization
# CRITICAL: Ensure this is active
setopt PROMPT_SUBST

# Your JOVIAL_PALETTE
typeset -gA JOVIAL_PALETTE=(
  host '%F{157}'      # For hostname 'melatonia'
  user '%F{253}'      # For username 'stardust'
  path '%B%F{228}'    # For directory path
  conj. '%F{102}'     # For 'as', 'in'
  typing '%F{252}'    # For '╰──➤'
  normal '%F{252}'    # For '╭─', brackets
  time '%F{254}'      # For time in RPS1
  success '%F{040}'   # For successful exit code
  error '%F{203}'     # For error exit code
  # ... other keys if you use them elsewhere ...
)

# --- Prompt Definition ---
PS1=""
PS1+="${JOVIAL_PALETTE[normal]}╭─["
PS1+="${JOVIAL_PALETTE[user]}%n%f"
PS1+="${JOVIAL_PALETTE[normal]}] "
PS1+="${JOVIAL_PALETTE[conj.]}as%f "
PS1+="${JOVIAL_PALETTE[host]}%m%f "
PS1+="${JOVIAL_PALETTE[conj.]}in%f "
PS1+="${JOVIAL_PALETTE[path]}%~%f"
PS1+=$'\n'
PS1+="${JOVIAL_PALETTE[typing]}╰──➤ %f"

RPS1='${JOVIAL_PALETTE[time]}%T%f'

# Aliases
# Orphan Packages
alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'

# Expicitly installed packages
alias packages='sudo pacman -Qe'

# easy cd ..
alias ..='cd ..'

# ls aliases
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias l.='ls -a --color=auto'
alias ll='ls -l --color=auto'
