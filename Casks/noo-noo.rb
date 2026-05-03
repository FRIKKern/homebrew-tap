cask "noo-noo" do
  version "0.5.0"
  sha256 "3149f806b5e956d107e2e64e7c009bb5a87eeaeed40b107c3f9b98e24f43443c"

  url "https://github.com/FRIKKern/noo-noo/releases/download/v#{version}/Noo-Noo-v#{version}.dmg"
  name "Noo-Noo"
  desc "Smart cleanup for Mac developers (menubar app + CLI)"
  homepage "https://github.com/FRIKKern/noo-noo"

  depends_on macos: ":big_sur"

  app "Noo-Noo.app"
  binary "#{appdir}/Noo-Noo.app/Contents/MacOS/noo-noo", target: "noo-noo"
  binary "#{appdir}/Noo-Noo.app/Contents/MacOS/noo-nood", target: "noo-nood"

  postflight do
    system_command "#{appdir}/Noo-Noo.app/Contents/MacOS/noo-noo",
                   args: ["install"],
                   sudo: false
  end

  uninstall launchctl: "io.noo-noo.d",
            delete:    [
              "~/Library/LaunchAgents/io.noo-noo.d.plist",
              "~/Library/Application Support/noo-noo",
            ]

  zap trash: [
    "~/.config/noo-noo",
    "~/Library/Logs/noo-noo",
    "~/Library/Caches/noo-noo",
  ]

  caveats <<~EOS
    Noo-Noo is ad-hoc signed (no Apple Developer ID yet). The first time
    you launch the app, macOS Gatekeeper will block it. To allow it:

      1. Right-click /Applications/Noo-Noo.app and choose "Open"
      2. Click "Open" in the confirmation dialog

    macOS will remember this choice. Apple Developer ID signing &
    notarization land in Phase 0.4.1.
  EOS
end
