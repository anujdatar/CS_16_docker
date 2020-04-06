#! /bin/bash

# The ex function from .bashrc in Manjaro
# I did not write this..

if [ -f $1 ] ; then
  case $1 in
    *.tar.bz2)   tar xjf $1   ;;
    *.tar.gz)    tar xzf $1   ;;
    *.bz2)       bunzip2 $1   ;;
    *.rar)       echo "unrar unavailable, RAR archives not compatible";;
    *.gz)        gunzip $1    ;;
    *.tar)       tar xf $1    ;;
    *.tbz2)      tar xjf $1   ;;
    *.tgz)       tar xzf $1   ;;
    *.zip)       echo "unzip unavailable, ZIP archives not compatible";;
    *.Z)         uncompress $1;;
    *.7z)        echo "7z unavailable, 7z archives not compatible";;
    *)           echo "'$1' not compatible, unable to extract archive" ;;
  esac
else
  echo "'$1' is not a valid file"
fi
