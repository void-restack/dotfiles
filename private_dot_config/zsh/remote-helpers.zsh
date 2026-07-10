# svim — edit ONE remote file in your local nvim (your full config + LSP).
#        Downloads it to a temp, opens nvim, uploads back only if you changed it.
#   svim implied .bashrc                 # path relative to the remote $HOME
#   svim implied /etc/nginx/nginx.conf   # absolute path
svim() {
  local host=$1 rpath=$2
  local dir tmp
  dir=$(mktemp -d) || return 1
  tmp="$dir/$(basename "$rpath")"
  scp -q "$host:$rpath" "$tmp" 2>/dev/null || : > "$tmp"
  local before after
  before=$(shasum "$tmp")
  nvim "$tmp"
  after=$(shasum "$tmp")
  if [[ "$before" != "$after" ]]; then
    scp -q "$tmp" "$host:$rpath" && echo "saved -> $host:$rpath"
  else
    echo "no changes"
  fi
  rm -rf "$dir"
}

# termfix — teach a FRESH server your kitty terminal. Fixes the
#           'xterm-kitty: unknown terminal type' error, broken colors and vim.
#           Run once per new server.
#   termfix implied
termfix() { infocmp -a xterm-kitty | /usr/bin/ssh "$1" 'mkdir -p ~/.terminfo && tic -x -o ~/.terminfo /dev/stdin'; }

# spull — download a remote FOLDER so you can edit the whole project locally.
#         rsync = only changed files transfer. 3rd arg = destination (default: here).
#   spull implied monitoring             # -> ./monitoring
#   spull implied /home/deploy/app ~/app # -> ~/app
spull() { rsync -av -e /usr/bin/ssh "$1:$2" "${3:-.}"; }

# spush — upload a local FOLDER back to the server (only changed files).
#   spush implied ./monitoring /home/deploy   # -> implied:/home/deploy/monitoring
spush() { rsync -av -e /usr/bin/ssh "$2" "$1:$3"; }
