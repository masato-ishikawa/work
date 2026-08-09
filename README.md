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
├── nix/ (予定)
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
