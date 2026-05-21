class Flux < Formula
  desc "Git + DVC auto-router — unified workflow for large and binary files via Cloudflare R2"
  homepage "https://github.com/bpeterme/flux"
  license "MIT"

  # Stable release fields — patched automatically by release.yml on each push to main.
  url    "https://github.com/bpeterme/flux/archive/refs/tags/2026.05.21.5.tar.gz"
  sha256  "9298910fed3a3e21001e13c8097bf2d91a6a5ea0501d5c4645375e5622a91ce4"
  version "2026.05.21.5"

  head "https://github.com/bpeterme/flux.git", branch: "dev"

  def install
    version_str = build.head? ? "HEAD-#{`git describe --tags --always`.chomp}" : version.to_s
    inreplace "flux", 'VERSION="dev"', "VERSION=\"#{version_str}\""
    # Hook and example config live in share/flux/ so flux add can find them.
    (share/"flux").install "pre-commit"
    (share/"flux").install "flux.env.example"
    bin.install "flux"
  end

  def caveats
    <<~EOS
      flux requires dvc — install it if you haven't already:
        pip install "dvc[s3]"

      Configure flux once per machine (stores credentials in macOS Keychain):
        flux config

      Then add flux to each Git repo you want to manage:
        cd your-repo && flux add
    EOS
  end

  test do
    assert_match "flux ", shell_output("#{bin}/flux version")
  end
end
