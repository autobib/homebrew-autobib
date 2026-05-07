class Autobib < Formula
  desc "Command-line tool for managing bibliographic records"
  homepage "https://github.com/autobib/autobib"
  url "https://github.com/autobib/autobib/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "859432b9591c8d63cc047aaddc214c1c9f93047ba1ba327ac5ce22f62bc8b75e"
  license "AGPL-3.0-or-later"

  head "https://github.com/autobib/autobib.git", branch: "main"

  bottle do
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.6.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "912fd0ccc4ec569dfeebaac4f71b150e96ab68ea70cb2e20d6e744e611b66021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0cce3f584cd5e29d3e1b8fc67d4ba07ac40f5fd27e965494b637dd7eeb89d84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8faf37048583412f9b472ce26a1399b6bf31210b10a3b6714ae24f421fedf6ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db83a7520f11581604d333e0f54e1ae8073440675f499daac015b5fcff1b3583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da722cedf499084229f0ea23b7f3f1e007f38e84c00335a4fb1492f772de59d"
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
