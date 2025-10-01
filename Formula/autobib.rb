class Autobib < Formula
  desc "Command-line tool for managing bibliographic records"
  homepage "https://github.com/autobib/autobib"
  url "https://github.com/autobib/autobib/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "77c3ffcd9a3fcdb18f13ef0ac030fd854bfbaf822954edd41c4079de30036a9b"
  license "AGPL-3.0-or-later"

  # remove revision on next release
  revision 1

  head "https://github.com/autobib/autobib.git", branch: "main"

  bottle do
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.4.0_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9c12c1251c948156f866b2f251a0b40d3bd1ed8ad9f944a81a78fc783d731b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d982465e48f86f0c3e7f26f3acbadfe8e1f45269e1f5c255f6d68a506ae3800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30bcad9730f6e9da112a61ce1c00107e14a064dbe99ae011fe3aef174daa367f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4dc06ba7ed74825a8ce48c17f483bda459a2b9a55278842708a69dbc2eae0ae"
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
