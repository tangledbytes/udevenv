# Load prompt first =========================================================================
## Custom Prompt -- Because ZSH Prompts sucks 🤷
eval "$(starship init zsh)"

# Load variables ============================================================================
source ${HOME}/.zsh-plugins/env.init.zsh

# Setup default ZSH options =================================================================
source ${HOME}/.zsh-plugins/opts.init.zsh

# Load autocomplete defaults ================================================================
source ${HOME}/.zsh-plugins/pre.autocomplete.plugin.zsh

# Load common aliases plugin ================================================================
source ${HOME}/.zsh-plugins/common-aliases.plugin.zsh

# Load git aliases plugin ===================================================================
source ${HOME}/.zsh-plugins/git.plugin.zsh

# Load Kubectl aliases plugin ===============================================================
source ${HOME}/.zsh-plugins/kubectl.plugin.zsh

# Load custom functions and alias ===========================================================
source ${HOME}/.zsh-plugins/custom.plugin.zsh

# Load custom colored man pages =============================================================
source ${HOME}/.zsh-plugins/colored-man-pages.plugin.zsh

# Load 3rd party plugins ====================================================================
source ${HOME}/.zsh-plugins/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source ${HOME}/.zsh-plugins/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${HOME}/.zsh-plugins/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${HOME}/.zsh-plugins/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Configure 3rd party plugin ================================================================
## VI Mode config
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

## History substring search plugin config
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
