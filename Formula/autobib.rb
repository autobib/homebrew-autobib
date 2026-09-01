class Autobib < Formula
  desc "Command-line tool for managing bibliographic records"
  homepage "https://github.com/autobib/autobib"
  url "https://github.com/autobib/autobib.git",
    using:    :git,
    tag:      "v0.7.0",
    revision: "4e242ba2cfc53eaaf5c5240b74130fc170ed9eaf"
  license "AGPL-3.0-or-later"

  revision 1

  head "https://github.com/autobib/autobib.git", branch: "main"

  bottle do
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.7.0_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d870b737416ae47c79c4a7435d43195e1e2a899031a86b212db0b1c35fc746f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "914abce16816882ff7e901f98cd8328cf32791c6ec3a1a24ff84ca3c79ec1160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "262875a6796c1426feaac78ac0985795603a4d2cabe832c0b9d3da514d0b9831"
    sha256 cellar: :any,                 arm64_linux:   "876bc882ba9813715e6341a19abbeeee6eed61efffde8e75d6a46e5fa67fe4e1"
    sha256 cellar: :any,                 x86_64_linux:  "5456bff4f10d14ee17abfd23959b497908d34271fb2d04d59800a7289a162b9c"
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
