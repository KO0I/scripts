#!/bin/zsh

open_vim(){
  exec xterm -bg \#4A3530 -fn -xos4-terminus-medium-*-normal-*-14-140-72-72-c-80-* -cr \#CCFFBB vim "$@"
}
