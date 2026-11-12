class Flux < Formula
  desc "Git + DVC auto-router — unified workflow for large and binary files via Cloudflare R2"
  homepage "https://github.com/bpeterme/flux"
  license "MIT"

  # Stable release fields — patched automatically by release.yml on each push to main.
  url    "https://github.com/bpeterme/flux/archive/refs/tags/2026.11.12.0.tar.gz"
  sha256  "160e5d73f4c881f2fad13dcd7702b9f4b5d51693249453b7ecd7253d91887bd0"
  version "2026.11.12.0"

  head "https://github.com/bpeterme/flux.git", branch: "dev"

  def install
    version_str = build.head? ? "HEAD-#{`git rev-parse --short HEAD`.chomp}" : version.to_s
    inreplace "flux", 'VERSION="dev"', "VERSION=\"#{version_str}\""
    # Hooks and example config live in share/flux/ so flux add can find them.
    (share/"flux").install "pre-commit"
    (share/"flux").install "pre-push"
    (share/"flux").install "post-checkout"
    (share/"flux").install "flux.env.example"
    bin.install "flux"
    zsh_completion.install "completions/_flux"
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
    assert_match "flux HEAD-", shell_output("#{bin}/flux version")
  end
end
