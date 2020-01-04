# Tmux Z-order Menu
Tmux plugin for z-order window switching.

### Introduction

A simple tmux plugin to display the current session's windows in z-order,  similar to  <kbd>⌘ Command</kbd> <kbd>⇥ Tab</kbd>.

![screenshot](https://user-images.githubusercontent.com/47395660/71772480-112ad700-2f54-11ea-9c05-a99a6bee92b9.gif)

### Key bindings

In any tmux mode:

- `<prefix> s` - Display the windows menu for the current tmux session ordered by last visited.


### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'avielsh/tmux-zorder-menu'


Hit `prefix + I` to fetch the plugin and source it. You should now be able to
use the plugin.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/avielsh/tmux-zorder-menu ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/tmux-zorder.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

You should now be able to use the plugin.

### Configuration

A couple of configuration options available:

    set -g @zorder_bindkey 'T'      # Bind T to Zorder menu
    set -g @zorder_max_history '15' # Maximum windows remembered = 15 
    

### License

[MIT](LICENSE.md)
