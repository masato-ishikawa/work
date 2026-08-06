# dotfiles

## 管理方針

| ツール | 管理対象 |
| --- | --- |
| Homebrew / Brewfile | パッケージ管理 |
| nix-darwin | macOSシステム設定 |
| GNU Stow | dotfile管理 |

パッケージはNixでは管理せず、Homebrewへ集約する。

## 構成

```text
.
├── brew/
├── stow/
└── README.md
```

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

### 外部Tapの信頼

Homebrewが外部Tapを信頼していない場合は、初回のみ明示的に許可します。

```sh
brew trust fluxcd/tap
brew trust controlplaneio-fluxcd/tap
```

## Stow

各パッケージ内は、ホームディレクトリから見た配置と同じ構造にします。

Ghosttyの設定は、次の対応になります。

```text
stow/ghostty/.config/ghostty/config
  -> ~/.config/ghostty/config
```

リポジトリのルートで、リンク内容を事前確認します。

```sh
stow --simulate --verbose --dir=stow --target="$HOME" ghostty
stow --dir=stow --target="$HOME" --restow ghostty
```

Fishも同様に適用できます。

```sh
stow --simulate --verbose --dir=stow --target="$HOME" fish
stow --dir=stow --target="$HOME" --restow fish
```

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
