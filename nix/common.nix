{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.defaults.dock = {
    # Dockを自動的に隠さない
    autohide = false;
    # ウインドウをしまうときにスケールエフェクトを使う
    mineffect = "scale";
    # 使用履歴に基づいて操作スペースを自動的に並べ替えない
    mru-spaces = false;
    # 最近使用したアプリをDockに表示しない
    show-recents = false;
    # Dockのアイコンサイズを32にする
    tilesize = 32;
  };

  # Finderの標準表示形式をリストにする
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";

  # スクリーンショットをDownloadsフォルダに保存する
  system.defaults.screencapture.location = "~/Downloads";

  # 壁紙クリックでデスクトップを表示するのはStage Manager使用時だけにする
  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
