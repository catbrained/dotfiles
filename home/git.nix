{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.email = "linda@catbrained.dev";
      user.name = "Linda Siemons";
      init.defaultBranch = "main";
      commit.gpgSign = true;
      tag.gpgSign = true;
      user.signingKey = "~/.ssh/id_ed25519";
      gpg.format = "ssh";
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
}
