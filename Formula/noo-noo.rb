class NooNoo < Formula
  desc "Smart cleanup for Mac developers (CLI-only, headless)"
  homepage "https://github.com/FRIKKern/noo-noo"
  url "https://github.com/FRIKKern/noo-noo/releases/download/v0.5.0/noo-noo-v0.5.0-darwin.tar.gz"
  version "0.5.0"
  sha256 "f22d36f3f4016143292d36cedb99bde21cc0cde84a31dab813baa5abad9f8496"
  license "MIT"

  depends_on :macos

  def install
    bin.install "noo-noo"
    bin.install "noo-nood"
  end

  service do
    run [opt_bin/"noo-nood", "run"]
    keep_alive true
    log_path var/"log/noo-nood.log"
    error_log_path var/"log/noo-nood.err.log"
  end

  test do
    assert_match "noo-noo", shell_output("#{bin}/noo-noo --version")
  end

  def caveats
    <<~EOS
      This formula installs the noo-noo CLI only (no menubar app).
      For the GUI app, install the cask instead:

        brew install --cask FRIKKern/tap/noo-noo

      To start the daemon:

        brew services start noo-noo
    EOS
  end
end
