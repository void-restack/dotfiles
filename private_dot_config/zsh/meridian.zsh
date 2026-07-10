# Meridian — Claude Code proxy (moc / mpi)
_meridian_start() {
  if ! lsof -nP -iTCP:3456 -sTCP:LISTEN &>/dev/null; then
    meridian &!
    sleep 1
  fi
}

moc() {
  _meridian_start
  ANTHROPIC_API_KEY=x ANTHROPIC_BASE_URL=http://127.0.0.1:3456 opencode "$@"
}

mpi() {
  _meridian_start
  ANTHROPIC_API_KEY=x ANTHROPIC_BASE_URL=http://127.0.0.1:3456 pi "$@"
}

alias meridian-down='killport 3456'
