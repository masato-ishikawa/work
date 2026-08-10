{ config, ... }:

let
  userHome = "/Users/${config.system.primaryUser}";
in {
  imports = [ ../common.nix ];

  system.primaryUser = "ishikawa";

  system.defaults.dock = {
    # Dockに固定するアプリ（現在の並び順）
    persistent-apps = [
      { app = "/System/Applications/Launchpad.app"; }
      { app = "/System/Applications/System Settings.app"; }
      { app = "/System/Applications/Notes.app"; }
      { app = "/System/Applications/Utilities/Screenshot.app"; }
      { app = "/Applications/Proton Authenticator.app"; }
      { app = "/Applications/LINE.app"; }
      { app = "/Applications/Prime Video.app"; }
      { app = "${userHome}/Applications/Ghostty.app"; }
      { app = "${userHome}/Applications/Visual Studio Code.app"; }
      { app = "${userHome}/Applications/Obsidian.app"; }
      { app = "${userHome}/Applications/ChatGPT.app"; }
      { app = "${userHome}/Applications/Google Chrome.app"; }
      { app = "${userHome}/Applications/Brave Browser.app"; }
    ];

    # Dock右側にDownloadsフォルダを配置する
    persistent-others = [
      {
        folder = {
          path = "${userHome}/Downloads";
          arrangement = "date-added";
          displayas = "folder";
          showas = "list";
        };
      }
    ];
  };
}
