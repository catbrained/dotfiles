{ ... }:
{
  # A `grep` replacement
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
    ];
  };
}
