let
  email = "gareth.stokes@paidright.io";
  name = "gareth";
  github = "garethstokes";
in {
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = github;
      push.autoSetupRemote = true;
    };
    userEmail = email;
    userName = name;
  };
}
