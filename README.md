# dotfiles

macOSの環境を再現するためのdotfilesです。

現在は、パッケージをHomebrew、ユーザー設定ファイルをGNU Stowで管理しています。将来的には、macOSのシステム設定をnix-darwinで管理します。

## 管理方針

ツールごとの責務を次のように分けます。

| ツール | 管理対象 |
| --- | --- |
| Homebrew / Brewfile | CLI、GUIアプリ、フォント |
| nix-darwin | DockやFinderなどのmacOSシステム設定 |
| GNU Stow | Ghostty、Fish、Gitなどのユーザー設定ファイル |

パッケージはNixでは管理せず、Homebrewへ集約します。同じパッケージを複数の仕組みで重複管理しないことを原則とします。

## 現在の構成

```text
.
├── brew/
│   ├── Brewfile       # すべてのMacで使うパッケージ
│   └── Brewfile.home  # 自宅Macだけで使うパッケージ
├── stow/
│   ├── fish/
│   │   └── .config/fish/
│   │       ├── config.fish
│   │       └── fish_plugins
│   └── ghostty/
│       └── .config/ghostty/config
└── README.md
```

会社Mac固有のパッケージが必要になった場合は、`brew/Brewfile.work`を追加します。端末名ではなく、`home`や`work`のような用途単位で差分を管理します。

## Homebrew

### 共通パッケージ

すべてのMacで共通して使うパッケージをインストールします。

```sh
brew bundle install --file=brew/Brewfile
```

### 自宅Mac

共通パッケージを適用した後、自宅Mac固有のパッケージをインストールします。

```sh
brew bundle install --file=brew/Brewfile
brew bundle install --file=brew/Brewfile.home
```

### インストール状況の確認

更新の有無を無視し、Brewfileに記載したパッケージがインストール済みか確認します。

```sh
brew bundle check --no-upgrade --file=brew/Brewfile
brew bundle check --no-upgrade --file=brew/Brewfile.home
```

不足または更新が必要な項目を表示する場合は、次を実行します。

```sh
brew bundle check --verbose --file=brew/Brewfile
```

### 外部Tapの信頼

Homebrewが外部Tapを信頼していない場合は、初回のみ明示的に許可します。

```sh
brew trust fluxcd/tap
brew trust controlplaneio-fluxcd/tap
```

信頼設定はBrewfileではなく、MacごとのHomebrew設定に保存されます。

### Cleanupの注意

Brewfileを共通用と端末固有用に分割しているため、一方のファイルだけを指定した`brew bundle cleanup`は実行しません。別のBrewfileにだけ記載されたパッケージが不要と判定される可能性があります。

## Stow

各パッケージ内は、ホームディレクトリから見た配置と同じ構造にします。Ghosttyの設定は、次の対応になります。

```text
stow/ghostty/.config/ghostty/config
  -> ~/.config/ghostty/config
```

リポジトリのルートで、リンク内容を事前確認します。

```sh
stow --simulate --verbose --dir=stow --target="$HOME" ghostty
```

問題がなければ適用します。

```sh
stow --dir=stow --target="$HOME" --restow ghostty
```

リンク先に通常ファイルがすでに存在する場合、Stowは上書きしません。既存ファイルを退避または削除してから適用します。

Fishも同様に適用できます。

```sh
stow --simulate --verbose --dir=stow --target="$HOME" fish
stow --dir=stow --target="$HOME" --restow fish
```

Fishでは、手書きの`config.fish`とFisherのプラグイン宣言`fish_plugins`だけを管理します。Tideが生成する`functions/`や`conf.d/`、端末固有の`fish_variables`は管理対象外です。

Fisher本体はBrewfileで管理しています。新しいMacではStowの適用後、`fish_plugins`に記載したTideを復元します。

```sh
fisher update
```

### Ghostty、Zellij、Fish

ターミナルは次の構成で起動します。

```text
Ghostty
└── Zellij: mainセッション
    └── Fish
```

GhosttyからZellijの固定`main`セッションを起動します。セッションが存在する場合は再接続し、存在しない場合はFishをデフォルトシェルとして新規作成します。

```ini
command = /opt/homebrew/bin/zellij options --session-name main --attach-to-session true --default-shell /opt/homebrew/bin/fish
```

Ghosttyが読み込んでいる実効設定は、次のコマンドで確認できます。

```sh
/Applications/Ghostty.app/Contents/MacOS/ghostty +show-config --changes-only
```

Ghosttyの設定は`Command + Shift + ,`で再読み込みできます。起動コマンドの変更は、新しいGhosttyプロセスから反映されます。

### Fish

対話シェルでは、`ll`を`eza`の詳細表示として定義しています。

```fish
alias ll="eza -l --icons --git"
```

隠しファイルは表示せず、ファイル種別のアイコンとGitの状態を表示します。Fish設定には、Homebrew、Google Cloud SDK、goenvのPATHと初期化処理も含めています。

変更を現在のFishへ反映する場合は、次を実行します。

```sh
source ~/.config/fish/config.fish
```

## 自宅Mac固有の環境

### Podman

Podman Desktopは使わず、CLI版のPodmanを管理します。初回のみLinux VMを作成します。

```sh
podman machine init
podman machine start
```

### MicroK8s

macOS向けの古いHomebrew Tapは利用しません。BrewfileではMultipassのみを管理し、MicroK8s本体はUbuntu VM内へSnapでインストールします。

```sh
multipass launch --name microk8s --cpus 2 --memory 4G --disk 20G
multipass exec microk8s -- sudo snap install microk8s --classic
multipass exec microk8s -- sudo microk8s status --wait-ready
```

## 今後の構成

nix-darwinを導入し、会社Mac固有のBrewfileやGit設定を追加する場合は、次の構成へ拡張します。

```text
.
├── flake.nix
├── flake.lock
├── nix/
│   ├── darwin.nix
│   └── defaults.nix
├── brew/
│   ├── Brewfile
│   ├── Brewfile.home
│   └── Brewfile.work
└── stow/
    ├── ghostty/
    │   └── .config/ghostty/config
    ├── fish/
    │   └── .config/fish/
    │       ├── config.fish
    │       └── fish_plugins
    └── git/
        └── .config/git/config
```

Stowの各パッケージ内は、ホームディレクトリから見た配置と同じ構造にします。例えば、`stow/ghostty/.config/ghostty/config`を`~/.config/ghostty/config`へリンクします。
