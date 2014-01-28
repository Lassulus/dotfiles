set -l FISH_HOME $HOME/.config/fish/

source $FISH_HOME/profile.fish

if test -f /usr/share/fry/fry.fish;
  source /usr/share/fry/fry.fish
end

if status --is-login
  source $FISH_HOME/login.fish
end

if status --is-interactive
  source $FISH_HOME/rc.fish
  source $FISH_HOME/solarized.fish
end

source "$HOME/.homesick/repos/homeshick/homeshick.fish"
