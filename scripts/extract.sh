#! /bin/bash

# This is the ex function from .bashrc in Manjaro Linux
# I did not write this function. not sure who did.
  ex() {
    if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1;;
      *.tar.gz)    tar xzf $1;;
      *.bz2)       bunzip2 $1;;
      *.rar)       unrar x $1;;
      *.gz)        gunzip $1;;
      *.tar)       tar xf $1;;
      *.tbz2)      tar xjf $1;;
      *.tgz)       tar xzf $1;;
      *.zip)       unzip $1;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1;;
      *)
        echo "'$1' not compatible, unable to extract archive"
        rm -rf $TARGET_DIR
        exit 1;;
    esac
  else
    echo "'$1' is not a valid file"
    rm -rf $TARGET_DIR
    exit 1
  fi
  }

  if [ -z "$TARGET_DIR" ]; then
    echo "Error: Archive extraction target not specified"
    exit 1
  fi

# Save current dir
CURRENT_DIR=$(pwd)

# make temp directory
mkdir -p $TARGET_DIR

# extract into target temp dir
cd $TARGET_DIR
ex $1

# go back to current dir
cd $pwd
