class Autobib < Formula
  desc "Command-line tool for managing bibliographic records"
  homepage "https://github.com/autobib/autobib"
  url "https://github.com/autobib/autobib/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5f9c58be5046918563c6fbeb7f0211a329f50edb2b36c026b4dbfc05c3fd3f43"
  license "AGPL-3.0-or-later"

  head "https://github.com/autobib/autobib.git", branch: "main"

  bottle do
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ac0e5ee9727fbc1cc0f2fe9300ae40a3f2ded9578f8c52a8cbc3ab446909e02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de60041afe02e0a548352f02911024a9278ec7bb2d702c6ae266c1b2e1210a49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd476348d2cbc1124243a9103cf3f86f566c5e9b7076478bb519e2deef5cd13e"
    sha256 cellar: :any,                 arm64_linux:   "74d2ea1b2c16def1bab739855f568ed546ba0fcbace39034547886ad7d6470a9"
    sha256 cellar: :any,                 x86_64_linux:  "1311874b6110ace6470bed96cc81b684fe8484e234ae172088f6dcf895f7a3ae"
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
