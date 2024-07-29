# Path to your oh-my-zsh installation.
export ZSH="/home/sail/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="steeef"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  debian
  colored-man-pages
  colorize
  command-not-found
  common-aliases
  composer
  dircycle
  git-flow-avh
  gitignore
  history
  npm
)

# Désactiver la vérification des répertoires non sécurisés
export ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

