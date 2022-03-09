# Load all files in $ZDOTDIR/scripts
for s in $(find "${ZDOTDIR}/scripts"); do
  [[ -f "$s" && -r "$s" ]] && source "$s"
done
