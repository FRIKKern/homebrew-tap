class Insomnia < Formula
  desc "Menu bar app that keeps your Mac awake, with lid-closed mode and guards"
  homepage "https://github.com/FRIKKern/insomnia"
  url "https://github.com/FRIKKern/insomnia/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c2906314b2347d7319eb140beacceaea5d1459e062d3e03c2cc38f0e399cc08a"
  license "MIT"
  head "https://github.com/FRIKKern/insomnia.git", branch: "main"

  depends_on macos: :ventura

  def install
    system "sh", "build.sh", "--no-install"
    prefix.install "build/Insomnia.app"
    (bin/"insomnia").write <<~EOS
      #!/bin/sh
      # insomnia            start the app
      # insomnia <command>  on | off | toggle | lid-on | lid-off | login-on | login-off | quit
      APP="#{opt_prefix}/Insomnia.app"
      if [ $# -eq 0 ]; then open "$APP"; exit 0; fi
      pgrep -x Insomnia >/dev/null 2>&1 || { open "$APP"; sleep 1; }
      open "insomnia://$1"
    EOS
  end

  def caveats
    <<~EOS
      Start Insomnia:            insomnia
      Launch at login:           insomnia login-on
      Control it from scripts:   insomnia on | off | toggle | lid-on | lid-off | quit
      The app lives at #{opt_prefix}/Insomnia.app
    EOS
  end

  test do
    assert_path_exists prefix/"Insomnia.app/Contents/MacOS/Insomnia"
  end
end
