# ── History ──────────────────────────────────────────────────────────────────
HISTFILE=~/.histfile
HISTSIZE=10000   # commands kept in memory during the session
SAVEHIST=10000   # commands kept in HISTFILE on disk

# Deduplicate the path/PATH array-scalar pair in place (typeset -U = unique).
# Keeps repeated `path+=(...)` appends further down from creating duplicate
# entries every time this file is re-sourced.
typeset -U path PATH

setopt extended_history      # record timestamp + duration of each command in HISTFILE
setopt hist_ignore_dups      # ignore consecutive duplicates
setopt hist_ignore_all_dups  # remove older duplicate entries from history, keep newest
setopt hist_ignore_space     # don't save commands prefixed with a space (quick "don't log this")
setopt hist_reduce_blanks    # remove superfluous blanks before recording
setopt share_history         # share history live across all open terminals
setopt append_history        # append rather than overwrite history on exit
setopt auto_cd               # type a dir name (no `cd`) to cd into it
setopt interactive_comments  # allow # comments in the interactive shell
# setopt correct               # suggest corrections for mistyped commands

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit

# Only regenerate .zcompdump once per day
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -i      # dump is stale (or missing) → rebuild, skip insecure-dir prompt
else
  compinit -C -i    # dump is fresh → trust it, skip the security check too
fi

zstyle :compinstall filename '$HOME/.zshrc'
zstyle ':completion:*' menu select                                               # arrow-key-navigable completion menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'  # case-insensitive + partial-word matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"                          # colorize completions like `ls`
zstyle ':completion:*' squeeze-slashes true                                      # collapse foo//bar → foo/bar
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'                # yellow section headers in the menu

# ── Keybindings ───────────────────────────────────────────────────────────────
bindkey -e  # Emacs keybindings

# ── Plugins ───────────────────────────────────────────────────────────────────
# Both guarded with [[ -f ]] so a fresh machine without these packages
# installed doesn't throw a "no such file" error on every new shell.

[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Greys out a suggested completion from history as you type; → or End to accept.
# NOTE: load order matters — autosuggestions should come after
# syntax-highlighting so highlighting doesn't get applied to the ghost
# suggestion text.
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ── Prompt ────────────────────────────────────────────────────────────────────
setopt PROMPT_SUBST
autoload -Uz add-zsh-hook
zmodload zsh/datetime  # provides $EPOCHREALTIME

typeset -gF _melo_cmd_start=0
typeset -gi _melo_last_exit=0

function _melo_preexec() {
  _melo_cmd_start=$EPOCHREALTIME;

  # 1. Extract only the first line of multi-line/pasted commands
  local cmd="${1%%$'\n'*}"
  # 2. Convert tabs to single spaces
  cmd="${cmd//$'\t'/ }"

  # 3. Output OSC 0 safely:
  #    -r         : Raw mode (never evaluate % or \ in user commands)
  #    -n         : Suppress extra trailing newline
  #    --         : Stop flag parsing (protects commands starting with '-')
  #    >/dev/tty  : Bypass Zsh stdout line-length tracking (prevents trailing '%')
  print -rn -- $'\e]0;' "${cmd[1,128]}" $'\a' >/dev/tty
}

function _melo_precmd_capture() { _melo_last_exit=$?; }

# Report cwd as the terminal tab title once the command finishes (OSC 0).
# Report file URL so COSMIC Terminal knows where to launch new tabs (OSC 7).
function _melo_set_title() {
  # OSC 0 : Reverts visual tab title to current directory (%~) when idle
  # OSC 7 : Informs COSMIC Terminal of $PWD so Ctrl+Shift+T spawns new tabs here
  print -Pn "\e]0;%~\a\e]7;file://${HOST:-localhost}${PWD}\a" >/dev/tty
}

function _melo_format_elapsed() {
  local -F e=$(( EPOCHREALTIME - _melo_cmd_start ))
  local -i s=$e
  local -i m=$(( s / 60 ))
  local -i h=$(( m / 60 ))

  if   (( s < 1  )); then printf ''
  elif (( h > 0  )); then printf '~%dh %dm' $h $(( m % 60 ))
  elif (( m > 0  )); then printf '~%dm %ds' $m $(( s % 60 ))
  else                    printf '~%ds'     $s
  fi
}

add-zsh-hook preexec _melo_preexec
add-zsh-hook precmd  _melo_precmd_capture  # must be registered FIRST
add-zsh-hook precmd  _melo_set_title

typeset -gA MELO_PALETTE=(
  host    '%F{#a5d6a7}'   # green200    – accent
  user    '%F{#eeeeee}'   # grey200    – near-white text
  path    '%B%F{#fff59d}' # yellow200  – bright path (bold preserved)
  conj.   '%F{#78909c}'   # blueGrey400 – muted separators
  git     '%F{#80cbc4}'   # teal200
  typing  '%F{#bdbdbd}'   # grey400    – prompt cursor line
  normal  '%F{#bdbdbd}'   # grey400    – structural chrome
  time    '%F{#e0e0e0}'   # grey300    – subtle right-prompt
  success '%F{#a5d6a7}'   # green200   – exit ok
  error   '%F{#ef9a9a}'   # red200     – exit fail
)

# ── Git branch (sync, lightweight) ───────────────────────────────────────────
typeset -g _melo_git_branch=""

function _melo_update_git() {
  local ref
  ref=$(git symbolic-ref HEAD 2>/dev/null) \
    || ref=$(git describe --tags --exact-match 2>/dev/null) \
    || ref=$(git rev-parse --short HEAD 2>/dev/null) \
    || { _melo_git_branch=""; return; }
  _melo_git_branch="${ref#refs/heads/}"
}

add-zsh-hook chpwd _melo_update_git
add-zsh-hook precmd _melo_update_git

# Jovial-style length helper: expands prompt sequences then strips ANSI codes
# (S%%) cannot handle hex %F{#rrggbb} colors — must strip ANSI bytes directly
function _melo_strlen() {
  local str="${(%)1}"
  local result=""
  local unstyle_regex=$'\e\[[0-9;]*[a-zA-Z]'
  while [[ -n $str ]]; do
    if [[ $str =~ $unstyle_regex ]]; then
      result+=${str[1,MBEGIN-1]}
      str=${str[MEND+1,-1]}
    else
      break
    fi
  done
  result+=$str
  echo ${#result}
}

function _melo_build_ps1() {
  local host_seg="${MELO_PALETTE[host]}%m%f"
  local user_seg="${MELO_PALETTE[user]}%n%f"
  local git_seg=""
  [[ -n $_melo_git_branch ]] && \
    git_seg="${MELO_PALETTE[conj.]} on %f${MELO_PALETTE[normal]}(%f${MELO_PALETTE[git]}${_melo_git_branch}${MELO_PALETTE[normal]})%f"

  local -i w_host=$(_melo_strlen "${host_seg}")
  local -i w_user=$(_melo_strlen "${user_seg}")
  local -i w_path=$(_melo_strlen "%~")
  local -i w_git=$(_melo_strlen "${git_seg}")

  local -i t_host=$(( 3 + w_host + 5 + w_user + 4 + w_path + w_git ))
  local -i t_user=$(( w_user + 4 + w_path + w_git ))
  local -i t_git=$(( w_git ))

  local host_block="${MELO_PALETTE[normal]}╭─[%f${host_seg}${MELO_PALETTE[normal]}] ${MELO_PALETTE[conj.]}as%f "
  local host_hidden="${MELO_PALETTE[normal]}╭─%f"

  PS1=""
  PS1+="%-${t_host}(l.${host_block}.${host_hidden})"
  PS1+="%-${t_user}(l.${user_seg} ${MELO_PALETTE[conj.]}in%f .)"
  PS1+="${MELO_PALETTE[path]}%~%b%f"
  [[ -n $_melo_git_branch ]] && PS1+="%-${t_git}(l.${git_seg}.)"
  PS1+=$'\n'
  PS1+="${MELO_PALETTE[typing]}╰──➤ %f"

  local elapsed_seg=""
  if (( _melo_cmd_start > 0 )); then
    local raw_elapsed=$(_melo_format_elapsed)
    if [[ -n $raw_elapsed ]]; then
      elapsed_seg="%F{#ffe082}$(_melo_format_elapsed)%f"
    fi
    _melo_cmd_start=0
  fi

  if   (( _melo_last_exit != 0 ));  then RPS1="${MELO_PALETTE[conj.]}exit:${MELO_PALETTE[error]}${_melo_last_exit}%f"
  elif [[ -n $elapsed_seg ]];       then RPS1="$elapsed_seg"
  else                                   RPS1="${MELO_PALETTE[time]}%B%T%b%f"
  fi
}

add-zsh-hook precmd _melo_build_ps1

# Redraw on terminal resize so time and responsive parts reflow
function _melo_winch() { zle && zle reset-prompt; }
trap '_melo_winch' WINCH

RPS1=""

# ── Aliases ───────────────────────────────────────────────────────────────────
alias zed='zeditor'
alias vim='nvim'
alias helix='hx'
alias ..='cd ..'
alias ...='cd ../..'

# zoxide (smart cd)
eval "$(zoxide init zsh --cmd cd)"

# fzf with fd backend
# key-bindings.zsh gives:
#   Ctrl+T (fuzzy-find file → insert path),
#   Alt+C (fuzzy-find dir → cd into it), Ctrl+R (fuzzy history search, nicer than zsh's built-in one).
[[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh

# fd instead of the default `find` backend — respects .gitignore, much
# faster, and these commands feed both Ctrl+T and Alt+C above.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --bind "ctrl-/:toggle-preview"' 

alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --all'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# lazygit — terminal UI for git
alias lg='lazygit'

# ls / eza — use eza (colorful, git-aware, icon-capable `ls` replacement)
# if installed, otherwise fall back to plain `ls` so this doesn't break
# on a machine that doesn't have it.
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lh --icons --group-directories-first --git'   # long listing + git status column
  alias la='eza -lah --icons --group-directories-first --git'  # long + all (dotfiles)
  alias l.='eza -a --icons --group-directories-first'          # just dotfiles, short form
  alias lt='eza --tree --icons --level=2'                      # directory tree, 2 levels deep
else
  alias ls='ls --color=auto'
  alias ll='ls -l --color=auto'
  alias la='ls -la --color=auto'
  alias l.='ls -a --color=auto'
fi

# list packages you explicitly installed (excludes deps pulled in automatically)
alias packages='dnf repoquery --userinstalled'

function update() {
  sudo dnf upgrade --refresh
  command -v rustup &>/dev/null && rustup update
  sudo dnf autoremove
  flatpak update
  flatpak uninstall --unused
}

export EDITOR=hx
export VISUAL=hx
export SUDO_EDITOR=hx

# Prepend user-local bin dirs so binaries installed there are found
# before system-wide ones of the same name.
path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.spicetify" $path)
export PATH


# ── Greeting ──────────────────────────────────────────────────────────────────
cat <<'EOF'
      |\      _,,,---,,_
ZZZzz /,`.-'`'    -.  ;-;;,_
     |,4-  ) )-,_. ,\ (  `'-'
    '---''(_/--'  `-'\_)  melo.
EOF

# bat — syntax-highlighted `cat`/pager replacement
# MANPAGER: strip man's backspace-encoded bold/underline (`col -bx`),
# then hand the plain text to bat with man-page syntax highlighting.
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME="base16"

# -p/--style=plain drops bat's line numbers/git-diff gutter so it reads
# like plain `cat` output, just with syntax highlighting kept.
alias cat='bat --paging=never --style=plain'
