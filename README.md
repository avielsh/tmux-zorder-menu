# Tmux Z-order Menu
Tmux plugin for z-order window switching.


### Key bindings

In any tmux mode:

- `s` - Display menu with current session's windows ordered by last visted


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

    set -g @zorder_bindkey T      # Bind T to zorder menu
    set -g @zorder_max_history 15 # Maximum windows remmembered = 15 
    

### License

[MIT](LICENSE.md)
