class Autobib < Formula
  desc "Command-line tool for managing bibliographic records"
  homepage "https://github.com/autobib/autobib"
  url "https://github.com/autobib/autobib/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "28f13478ea64f809c79b584b23bdbedd559742f906a15386517177fff4d6bef5"
  license "AGPL-3.0-or-later"

  head "https://github.com/autobib/autobib.git", branch: "main"

  bottle do
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.5.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f63181c51c6b67a679eb71dc2123c8eaea3f84d8eb78e674517b0b17d14615f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "807ac1a6f201c31f691502069dc2c35702b4e2dbbc2194b375840ce2cfc67062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3655f2f2e4691cd4b6c61c8fc12f4d6031bfab1387845479426ad0a7be245a43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ff5901093c2058ee0213295c0c6a3af38a4e36ac5dd13cf38a01f22930a83a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c300b5f800b5566c2be7f9a58f7feeaec49af44c16a28a82e05078f3795394"
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
