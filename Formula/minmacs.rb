class Minmacs < Formula
  desc "Menu bar app and CLI that reclaims CPU and RAM for developers and agents"
  homepage "https://github.com/FRIKKern/minmacs"
  url "https://github.com/FRIKKern/minmacs/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "bd1b64eb950521908e3c0e4290f48636cea191aa3afd599d628da3ffc2d5d623"
  license "MIT"
  head "https://github.com/FRIKKern/minmacs.git", branch: "main"

  depends_on macos: :ventura

  def install
    system "sh", "build.sh", "--no-install"
    prefix.install "build/MinMacs.app"
    (bin/"minmacs").write <<~EOS
      #!/bin/sh
      # minmacs                start the menu bar app
      # minmacs plan|run|restore|rules [--json] [--yes] [--only <bundle-id>]
      APP="#{opt_prefix}/MinMacs.app"
      if [ $# -eq 0 ]; then open "$APP"; exit 0; fi
      exec "$APP/Contents/MacOS/MinMacs" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Start the menu bar app:   minmacs
      See the plan:             minmacs plan
      Close the close list:     minmacs run
      The app lives at #{opt_prefix}/MinMacs.app
    EOS
  end

  test do
    assert_path_exists prefix/"MinMacs.app/Contents/MacOS/MinMacs"
  end
end
