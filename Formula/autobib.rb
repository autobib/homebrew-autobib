class Autobib < Formula
  desc "Command-line tool for managing bibliographic records"
  homepage "https://github.com/autobib/autobib"
  url "https://github.com/autobib/autobib/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "4f641d455075af0baac3a67e28388eb8bcf837c5002c70959efa3a52e5681d38"
  license "AGPL-3.0-or-later"

  head "https://github.com/autobib/autobib.git", branch: "main"

  bottle do
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb382931bae3fea2f7419d4193188c5022d4fba24447ecf3a5929bd1df2be595"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eda94a668a35c777415964cb04204366a140358b6aa9c17c4d3acf97f0c7363b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00996499dde0adbb9eac020d3ac30d3cccdad27a886c86a0b0159100b50b5d3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2123a1fe1bbd99a360270dec7864674df063743035f957ea0347d7c6d91468e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0925156d97486b5c0e72c8bff61b5416dec54de279cdc3fe5fec4047bec15fce"
  end

  depends_on "cargo-about" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    doc.install "README.md", "COPYRIGHT", "LICENSE"
    if build.bottle?
      system "cargo-about", "generate",
        "--config", "about/config.toml",
        "--output-file", doc/"third-party-licenses.html",
        "about/template.hbs"
    end

    generate_completions_from_executable(bin/"autobib", "completions")
  end

  test do
    assert_equal "autobib #{version}", shell_output("#{bin}/autobib --version").strip
  end
end
