# dotfiles

## 管理方針

| ツール | 管理対象 |
| --- | --- |
| Homebrew / Brewfile | パッケージ管理 |
| nix-darwin | macOSシステム設定 |
| Stow | dotfiles管理 |

パッケージはNixでは管理せず、Homebrewへ集約する。

## 構成

```text
.
├── brew/
├── stow/
├── nix/
└── README.md
```

## Homebrew

Homebrewでインストールするアプリケーションは、ホームディレクトリ配下の`Applications`（`$HOME/Applications`）に配置する。

### 共通パッケージ

すべてのMacで共通して使うパッケージをインストールする。

```sh
brew bundle install --file=brew/Brewfile
```

### 追加パッケージ

共通パッケージを適用した後、追加パッケージをインストールする。

```sh
brew bundle install --file=brew/home/Brewfile
```

## nix-darwin

macOSのシステム設定を管理する。現在は、Dockを自動的に隠さない設定を適用する。

共通設定は`nix/common.nix`、端末固有のユーザー名などは`nix/hosts/`配下で管理する。会社Macへ適用する前に、`nix/hosts/work.nix`のユーザー名を設定する。

### Nixのインストール

Nix互換のLixを公式インストーラーでインストールする。

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh -s -- install
```

インストール後にターミナルを開き直し、動作を確認する。

```sh
nix --version
```

### nix-darwinの適用

初回適用

```sh
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ./nix#home
```

2回目以降

```sh
sudo darwin-rebuild switch --flake ./nix#home
```

会社Mac

```sh
sudo darwin-rebuild switch --flake ./nix#work
```

## Stow

各パッケージ内は、ホームディレクトリから見た配置と同じ構造にする。

Ghostty設定の適用

```sh
stow --dir=stow --target="$HOME" --restow ghostty
```

Fish設定の適用

```sh
stow --dir=stow --target="$HOME" --restow fish
fisher update
```

### ターミナル構成

```text
Ghostty
└── Zellij: mainセッション
    └── Fish
```
