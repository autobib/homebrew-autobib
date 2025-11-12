class Autobib < Formula
  desc "Command-line tool for managing bibliographic records"
  homepage "https://github.com/autobib/autobib"
  url "https://github.com/autobib/autobib/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d6165b4b465f2846d86755b6b4f7029c9b6d5a4e031ca58f71a4df6d2300341e"
  license "AGPL-3.0-or-later"

  head "https://github.com/autobib/autobib.git", branch: "main"

  bottle do
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ead2b00e447567ffe19a6cc732250aab8224bb6e8b8f3678cf25af08712cac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4dfe630c6b6fba9931a2b6bac2dfb74f530602347ba28746b29f0545b4350e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af91ebfa4979092e04988ecc4061dbee7a0d083068e3c9fb83fb09ba4acc60e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "297fc4acb33f7562ff9d135f4c913dcc5f88f76ab86f7642e14f17b16ae7c3ff"
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
