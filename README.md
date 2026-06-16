# homebrew-autobib

Homebrew [tap](https://docs.brew.sh/Taps) for Autobib formulae.

## How to use the tap

Run `brew install autobib/autobib/<formula>` to install a formula.

For example, to install the main [Autobib](https://github.com/autobib/autobib) formula, run `brew install autobib/autobib/autobib`.

Alternatively, run `brew tap autobib/autobib` followed by `brew install <formula>`.
Or, in a [`Brewfile`](https://docs.brew.sh/Brew-Bundle-and-Brewfile):

```ruby
tap "autobib/autobib"
brew "<formula>"
```

## Updating formulae

Formulae can be updated by manually opening a PR or using the GitHub workflows in this repo (access restrictions apply).
See [docs/formula-bumps.md](docs/formula-bumps.md) for details.

### Need help with Homebrew?

Run `brew help` or `man brew`, or check [Homebrew's documentation](https://docs.brew.sh).
