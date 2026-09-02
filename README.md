# homebrew-autobib

Homebrew [tap](https://docs.brew.sh/Taps) for Autobib formulae.

## How to use the tap

To install a formula, run:

```sh
brew install autobib/autobib/<formula>
```

For example, to install the main [Autobib](https://github.com/autobib/autobib) formula, run `brew install autobib/autobib/autobib`.

Alternatively, if you prefer to use [`brew bundle`](https://docs.brew.sh/Brew-Bundle-and-Brewfile), add the following declarations to your `Brewfile`:

```ruby
tap "autobib/autobib"
brew "autobib/autobib/<formula>", trusted: true
```

## Updating formulae

Formulae can be updated by manually opening a PR or using the GitHub workflows in this repo (access restrictions apply).
See [docs/formula-bumps.md](docs/formula-bumps.md) for details.

### Need help with Homebrew?

Run `brew help` or `man brew`, or check [Homebrew's documentation](https://docs.brew.sh).
