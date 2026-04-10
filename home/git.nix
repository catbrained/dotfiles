{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_ed25519";
    };
    settings = {
      user.email = "linda@catbrained.dev";
      user.name = "Linda Siemons";
      init.defaultBranch = "main";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      # Diffing
      diff = {
        algorithm = "patience";
      };
    };
  };

  home.file.".config/git/allowed_signers".text = ''
    linda@catbrained.dev ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIAsoKQZS3EtdVd/wdw+m30ZAe5shaz1R+HENhwaVcHs linda@catbrained.dev
  '';

  home.packages = [
    pkgs.git-agecrypt
  ];
}
