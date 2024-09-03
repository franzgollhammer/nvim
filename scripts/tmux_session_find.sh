#!/bin/bash

# if not currently in tmux
if [ -z "$TMUX" ]; then
  # tmux is not active
  echo "is not tmux"
  # save fzf to variables
  ZOXIDE_RESULT=$(zoxide query -l | fzf --reverse)

  # if empty exit
  if [ -z "$ZOXIDE_RESULT" ]; then
    exit 0
  fi

  FOLDER=$(basename $ZOXIDE_RESULT)

  # lookup tmux session name
  SESSION=$(tmux list-sessions | grep $FOLDER | awk '{print $1}')
  SESSION=${SESSION//:/}
  echo $SESSION
  
  if [ -z "$SESSION" ]; then
    # session does not exist
    echo "session does not exist"
    # jump to directory
    cd $ZOXIDE_RESULT
    # create session
    tmux new-session -s $FOLDER
  else
    # session exists
    echo "session exists"
    # attach to session
    tmux attach -t $SESSION
  fi
else
  # tmux is active
  echo "is tmux"
  # save fzf to variables
  ZOXIDE_RESULT=$(zoxide query -l | fzf --reverse)

  # if no result exit
  if [ -z "$ZOXIDE_RESULT" ]; then
    exit 0
  fi

  FOLDER=$(basename $ZOXIDE_RESULT)
  # lookup tmux session name
  SESSION=$(tmux list-sessions | grep $FOLDER | awk '{print $1}')
  SESSION=${SESSION//:/}

  if [ -z "$SESSION" ]; then
    # session does not exist
    echo "session does not exist"
    # jump to directory
    cd $ZOXIDE_RESULT
    # create session
    tmux new-session -d -s $FOLDER
    # attach to session
    tmux switch-client -t $FOLDER
  else
    # session exists
    echo "session exists"
    # attach to session
    # switch to tmux session
    tmux switch-client -t $SESSION
  fi
fi
