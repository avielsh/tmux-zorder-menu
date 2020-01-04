#!/usr/bin/env zsh

# Possible configurations
zorder_bindkey='@zorder_bindkey'
zorder_max_history='@zorder_max_history'

zorder=($(tmux show-options -v @zorder))
scriptname="$0:A"
[[ $1 == "zorder_show_menu" ]] && local zorder_show_menu=1

#Defaults
default_max_history=8
default_zorder_bindkey="s"

init() {
  bind_key=$(tmux_option "$zorder_bindkey" "$default_zorder_bindkey") 
  tmux bind $bind_key run-shell "$scriptname zorder_show_menu"
  
  tmux set-hook -g after-select-window "run $scriptname"
  tmux set-hook -g after-new-window "run $scriptname"

  #Init @zorder
  active_window=$(get_active_window)
  [[ -z $active_window ]] && zorder=1 || zorder=${active_window}
  tmux set  @zorder $zorder
}

tmux_option() {
    local -r value=$(tmux show-option -gqv "$1")
    local -r default="$2"

    if [ ! -z "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}

get_active_window() {
  tmux list-windows -F '#{window_index} #{window_active}' | awk '$2==1 {print $1}' 
}

choose_window() {
  local -r zorder_sorted=(${zorder[2,${#zorder}]}) 
  local -r windows_info="$(tmux list-windows -F '#{window_index} #{window_name} #{pane_current_command}')"
  local menu=()

  local item=1
  for i in ${zorder_sorted[@]}
  do
    local window_details=$(echo "$windows_info" | grep "^$i")
    menu+=("Window $window_details" $item "select-window -t $i")
    item=$((item+1))
  done
  #Insert currently active window
  window_details=$(echo $windows_info | grep "${zorder[1]}")
  current_active_window=("Current: $window_details" $item "select-window -t ${zorder[1]}")

  tmux display-menu -x W -y S -T "Switch window (Z-order)" "$menu[@]" '' $current_active_window
}

main() {
  [[ -z $zorder ]] && init
  local active_window=$(get_active_window)
  local max_history=$(tmux_option "$zorder_max_history" "$default_max_history") 

  [[ $zorder_show_menu -eq 1 ]] && choose_window
  
  #Store current zorder list
  zorder=($active_window "${(@)zorder:#${active_window}}")
  local S_zorder="$zorder[1,${max_history}]"
  tmux set @zorder "$S_zorder"
}

main
