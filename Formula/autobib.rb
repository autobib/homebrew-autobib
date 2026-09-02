class Autobib < Formula
  desc "Command-line tool for managing bibliographic records"
  homepage "https://github.com/autobib/autobib"
  url "https://github.com/autobib/autobib.git",
    using:    :git,
    tag:      "v0.7.1",
    revision: "72ecddfe4e4b5a5c117e31c5db6160f81e1724c6"
  license "AGPL-3.0-or-later"

  head "https://github.com/autobib/autobib.git", branch: "main"

  bottle do
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.7.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c68db5cc5ec1871e6cd2fdedbbb43c0431517d8d357f9cf1e4491a327a39f31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc0b0dc513da90bb23e2bcaff6dd29d57ad433ee8cad4d9eb385880481de3881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c01772ff72fb97b2afaa81482b789ea29dcec50e5adfbdea66f785e31382a9e5"
    sha256 cellar: :any,                 arm64_linux:   "50a553d7dbecd68d4e27fd8646ed09d1805289bcb48c0cedbb48fb072671fb13"
    sha256 cellar: :any,                 x86_64_linux:  "1c73d99a7ab4832cb68fd8d22380cd99b608cffdc06bb95bdd9062a0e3930726"
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
