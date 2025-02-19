#! bash oh-my-bash.module
# Work Theme, an customization of "Sexy"
# Screenshot: TBD

if [[ $COLORTERM == gnome-* && $TERM == xterm ]] && infocmp gnome-256color &>/dev/null; then
  export TERM=gnome-256color
elif [[ $TERM != dumb ]] && infocmp xterm-256color &>/dev/null; then
  export TERM=xterm-256color
fi

MAGENTA=$_omb_prompt_bold_red
WHITE=$_omb_prompt_bold_silver
ORANGE=$_omb_prompt_bold_olive
GREEN=$_omb_prompt_bold_green
PURPLE=$_omb_prompt_bold_purple
RESET=$_omb_prompt_normal
if ((_omb_term_colors >= 256)); then
  ORANGE=$_omb_prompt_bold'\['$(tput setaf 172)'\]'
  GREEN=$_omb_prompt_bold'\['$(tput setaf 190)'\]'
  PURPLE=$_omb_prompt_bold'\['$(tput setaf 141)'\]'
fi

PROMPT_DIRTRIM=6
OMB_PROMPT_VIRTUALENV_FORMAT=$WHITE'🐍 '
OMB_PROMPT_CONDAENV_FORMAT=$WHITE'<%s> '
OMB_PROMPT_CONDAENV_USE_BASENAME=true
OMB_PROMPT_SHOW_PYTHON_VENV=true

function parse_git_dirty {
  [[ $(_omb_prompt_git status 2> /dev/null | tail -n1 | cut -c 1-17) != "nothing to commit" ]] && _omb_util_print "*"
}
function parse_git_branch {
  _omb_prompt_git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function _omb_theme_PROMPT_COMMAND() {
  local python_venv
  _omb_prompt_get_python_venv
  local git_prefix=
  [[ $(_omb_prompt_git branch 2> /dev/null) ]] && git_prefix=' on '
  PS1=$python_venv$MAGENTA'\u'
  PS1+=' '$WHITE' '$GREEN'\w'$WHITE
  PS1+=$git_prefix$PURPLE'$(parse_git_branch)'$WHITE'\n\$ '$RESET
}

_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND
