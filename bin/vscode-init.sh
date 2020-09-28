#!/usr/bin/env bash

set -eu

. $HOME/src/github.com/artifactsauce/proglets/lib/bash/logger

SRCDIR="$(dirname "$(realpath "$0")")"
LIBSETTINGDIR="$HOME/Library/Application Support/Code/User"
HOMESETTINGDIR="$HOME/.vscode"

usage_exit() {
  cat <<EOF
Usage: $0 [-c | -i | -r]
Options:
  -c  clean setting directories
  -i  install extensions
  -r  delete and reinstall extensions
EOF
}

cd "$LIBSETTINGDIR"

logger.info "Force create symlinks"
while read; do
  logger.debug "Create a symlink to $SRCDIR/$REPLY"
  [ -d "$REPLY" ] && rm -rf "$REPLY"
  ln -sf "$SRCDIR/$REPLY" "$REPLY"
done < <(ls "$SRCDIR" | grep -v "$(basename $0)")

while getopts cirh OPT; do
  case $OPT in
    c)
      logger.info "Delete setting file directory in Library: $LIBSETTINGDIR"
      rm -rf "$LIBSETTINGDIR"
      logger.info "Delete setting file directory in Home: $HOMESETTINGDIR"
      rm -rf "$HOMESETTINGDIR"
      ;;
    i)
      logger.info "Install vscde extensions"
      mpkg install vscode
      ;;
    r)
      logger.info "Delete extensions directory: $HOMESETTINGDIR/extensions"
      rm -rf "$HOMESETTINGDIR/extensions"
      logger.info "Install vscde extensions"
      mpkg install vscode
      ;;
    h)
      usage_exit
      ;;
    \?)
      usage_exit
      ;;
  esac
done
shift $((OPTIND - 1))
