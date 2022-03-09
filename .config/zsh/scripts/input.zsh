bindkey -e

autoload -U compinit; compinit
_comp_options+=(globdots)

fpath=("$ZDOTDIR/prompts" $fpath)
autoload -Uz purification; purification

