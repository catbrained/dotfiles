{ pkgs, writeShellApplication }:
writeShellApplication {
  name = "new-project";
  runtimeInputs = [
    pkgs.bash
    pkgs.lix
    pkgs.jq
    pkgs.fzf
  ];
  text = ''
    TEMPLATES=$(nix flake show --json ~/dev/personal/dotfiles 2>/dev/null | jq '.templates')
    export TEMPLATES
    # shellcheck disable=SC2016
    SELECTED=$(echo "$TEMPLATES" | jq -r 'keys[]' | fzf --with-shell='bash -c' --preview='echo "$TEMPLATES" | jq -r --arg v {} '"'"'.[$v] | .description'"'"' ')
    nix flake init -t ~/dev/personal/dotfiles#"$SELECTED"
  '';
}
