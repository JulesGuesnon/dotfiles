{
  shellInit = ''
    export PATH="~/.fnm:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    export LANG=en_US.UTF-8

    alias c='cd $(git rev-parse --show-toplevel)'
    alias n='nvim .'
    alias k='kubectl'
    alias l='ls -la'

    cdn ()
    {
      cd $1 && nvim .
    }

    system_reload ()
    {
      nix run nix-darwin -- switch --flake ~/.config/nix-darwin#default
    }
  '';
  interactiveShellInit = { pkgs }: ''
    eval "$(starship init zsh)"

    source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    autoload -U compinit; compinit
    source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
  '';
  loginShellInit = ''
    eval "`fnm env --use-on-cd`"
  '';
}
