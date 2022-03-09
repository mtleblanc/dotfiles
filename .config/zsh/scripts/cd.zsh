setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
alias d='dirs -v'

for index ({1..9}); do
  alias "$index"="cd +${index}"
done
unset index
