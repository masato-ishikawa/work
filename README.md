# dotfiles

macOSの環境を再現するためのdotfilesです。

現在はHomebrewによるパッケージ管理から整備しています。将来的には、macOSのシステム設定をnix-darwin、ユーザー設定ファイルの配置をGNU Stowで管理します。

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

nix-darwinとStowを導入する場合は、次の構成へ拡張します。

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
    │   └── .config/fish/config.fish
    └── git/
        └── .config/git/config
```

Stowの各パッケージ内は、ホームディレクトリから見た配置と同じ構造にします。例えば、`stow/ghostty/.config/ghostty/config`を`~/.config/ghostty/config`へリンクします。
