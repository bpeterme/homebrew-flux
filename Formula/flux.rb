class Flux < Formula
  desc "Git + DVC auto-router — unified workflow for large and binary files via Cloudflare R2"
  homepage "https://github.com/bpeterme/flux"
  license "MIT"

  # Stable release fields — patched automatically by release.yml on each push to main.
  url    "https://github.com/bpeterme/flux/archive/refs/tags/2026.11.17.1.tar.gz"
  sha256  "9160d2eceacdc3ba5ae11fbfd6734a1ffa01b9a95211b174314a2d8f3835b744"
  version "2026.11.17.1"

  head "https://github.com/bpeterme/flux.git", branch: "dev"

  def install
    version_str = build.head? ? "HEAD-#{`git rev-parse --short HEAD`.chomp}" : version.to_s
    inreplace "flux", 'VERSION="dev"', "VERSION=\"#{version_str}\""
    # Hooks live in share/flux/ so flux add can find them.
    (share/"flux").install "pre-commit"
    (share/"flux").install "pre-push"
    (share/"flux").install "post-checkout"
    bin.install "flux"
    zsh_completion.install "completions/_flux"
  end

  def caveats
    <<~EOS
      flux requires dvc — install it if you haven't already:
        pip install "dvc[s3]"

      Configure flux once per machine (credentials go to the macOS Keychain,
      on Linux to the desktop keyring):
        flux config

      Then add flux to each Git repo you want to manage:
        cd your-repo && flux add
    EOS
  end

  test do
    assert_match "flux HEAD-", shell_output("#{bin}/flux version")
  end
end
