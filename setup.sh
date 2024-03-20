#!/bin/bash

TMPDIR=$(mktemp -d)

CURRENT=$PWD

cd $TMPDIR

# for script in ~/.dotfiles/scripts/*; do
#   bash "$script"
# done

bash "~/.dotfiles/scripts/prep_gpg.sh"

bash "~/.dotfiles/scripts/shellcheck.sh"

cd $CURRENT

rm -rf $TMPDIR
