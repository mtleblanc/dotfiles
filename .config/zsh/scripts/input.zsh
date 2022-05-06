bindkey -e

autoload -U compinit
if [ -z "$XDG_CACHE_HOME" ]
then
  compinit
else
  compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
fi

_comp_options+=(globdots)

fpath=("$ZDOTDIR/prompts" $fpath)
autoload -Uz purification; purification

fpath=("$ZDOTDIR/functions" $fpath)

# autoload all functions
for s in $(find "${ZDOTDIR}/functions"); do
  [[ -f "$s" && -r "$s" ]] && autoload "$s"
done
