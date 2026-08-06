# dotfiles

## 管理方針

| ツール | 管理対象 |
| --- | --- |
| Homebrew / Brewfile | パッケージ管理 |
| nix-darwin | macOSシステム設定 |
| GNU Stow | dotfiles管理 |

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

### 共通パッケージ

すべてのMacで共通して使うパッケージをインストールする。

```sh
brew bundle install --file=brew/Brewfile
```

### 自宅Mac

共通パッケージを適用した後、自宅Mac固有のパッケージをインストールする。

```sh
brew bundle install --file=brew/Brewfile
brew bundle install --file=brew/Brewfile.home
```

### 外部Tapの信頼

Homebrewが外部Tapを信頼していない場合は、初回のみ明示的に許可する。

```sh
brew trust fluxcd/tap
brew trust controlplaneio-fluxcd/tap
```

## Stow

各パッケージ内は、ホームディレクトリから見た配置と同じ構造にする。

Ghosttyの設定の適用

```sh
stow --simulate --verbose --dir=stow --target="$HOME" ghostty
stow --dir=stow --target="$HOME" --restow ghostty
```

Fishの設定の適用

```sh
stow --simulate --verbose --dir=stow --target="$HOME" fish
stow --dir=stow --target="$HOME" --restow fish
fisher update
```

### Ghostty、Zellij、Fish

ターミナルは次の構成で起動する。

```text
Ghostty
└── Zellij: mainセッション
    └── Fish
```
