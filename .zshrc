ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-vi-mode)
# use fzf on control r
source <(fzf --zsh)
# always start in insert mode
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
