#!/usr/bin/env zsh
scriptname="$0:A"

# Possible configurations
zorder_bindkey='@zorder_bindkey'
zorder_max_history='@zorder_max_history'
zorder_window_info_format='@zorder_window_info_format'


#Defaults
default_max_history=8
default_zorder_bindkey="Tab"
default_window_format='#{window_name} #{pane_current_command}'


init() {
  bind_key=$(tmux_option "$zorder_bindkey" "$default_zorder_bindkey") 
  tmux bind $bind_key run-shell "$scriptname show_menu"
  tmux set @zorder_init 1
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

choose_window() {
  local max_history=$(tmux_option "$zorder_max_history" "$default_max_history") 
  local zorder=($(tmux list-windows -F "#{window_index} #{window_stack_index}" |sort -k2 | awk '{print $1}' | tr '\n' ' '))
  local -r window_info_format="#{window_index}: $(tmux_option "$zorder_window_info_format" "$default_window_format")"
  local -r windows_info="$(tmux list-windows -F $window_info_format | sed "s|$HOME|~|" )"
  local menu=()

  local kbd_key=1
  for i in $(echo ${zorder[2,$max_history]})
  do
    local current_window_details=$(echo "$windows_info" | grep "^$i")
    menu+=("Window $current_window_details" $kbd_key "select-window -t $i")
    kbd_key=$((kbd_key+1))
  done
  #Insert currently active window
  current_window_details=$(echo $windows_info | grep "^${zorder[1]}")
  current_active_window=("Current: $current_window_details" $kbd_key "select-window -t ${zorder[1]}")
  # echo Debug
   # echo "$menu[@]"
  tmux display-menu -x W -y S -T "Switch window (Z-order)" "$menu[@]" '' $current_active_window
}

usage() {
cat <<EOF
Tmux Z-order menu plugin
Usage: $scriptname:t [show_menu]
Run the script without arguments to initialize with tmux

show_menu - Display the window switch menu
-h|--help - Prints this help

EOF

}
#parse arguments
[[ $1 == show_menu ]] && show_menu=1
[[ $1 == "-h" || $1 == "--help" ]] && usage && return 0

main() {
  zorder_started=$(tmux show-option -qv "@zorder_init")
  [[ -z $zorder_started ]] && init

  [[ ! -z $show_menu ]] && choose_window
}

main
