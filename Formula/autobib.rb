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
    root_url "https://github.com/autobib/homebrew-autobib/releases/download/autobib-0.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "3af3d0fe01ca05abbe269b6b33a7580e9cc68883735b2644198a33af8186c766"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7dd7a44440ef36c8d59b780ede53814adaa8c8638b017a5eaa1ead0a485d2f14"
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
