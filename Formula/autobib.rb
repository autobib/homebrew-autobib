class Autobib < Formula
  desc "Command-line tool for managing bibliographic records"
  homepage "https://github.com/autobib/autobib"
  url "https://github.com/autobib/autobib/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "4a5015da63c856a3bc131bd565899332d2be40d62efded84cda9ccdd09e3e25e"
  license "AGPL-3.0-or-later"

  head "https://github.com/autobib/autobib.git", branch: "main"

  bottle do
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.4.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee0d381110efbc086e2d7e5edd494a86ded3bbfe56ace72b818285cb30405eb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b29d552309bff16a87b945f51d832e2faadc6b055bd9e72c7f048281fe7b1577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dcd7028b8b01dc3e2811891bc5ae975226fd4b8b0b976388c123e5c5f6c5b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d791135017c9ccacac7718a9ae1146ede9126941dff142c9dbe82752ba8f908"
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
