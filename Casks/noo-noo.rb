cask "noo-noo" do
  version "0.6.0"
  sha256 "19ff5ac5f7fb489f805fa0f800c5330d34812ef9b3b671807d42535fd0a93121"

  url "https://github.com/FRIKKern/noo-noo/releases/download/v#{version}/Noo-Noo-v#{version}.dmg"
  name "Noo-Noo"
  desc "Smart cleanup for Mac developers (menubar app + CLI)"
  homepage "https://github.com/FRIKKern/noo-noo"

  depends_on macos: :big_sur

  app "Noo-Noo.app"
  binary "#{appdir}/Noo-Noo.app/Contents/Resources/bin/noo-noo", target: "noo-noo"
  binary "#{appdir}/Noo-Noo.app/Contents/Resources/bin/noo-nood", target: "noo-nood"

  postflight do
    # Ad-hoc signed: macOS Sequoia SIGKILLs a quarantined binary run from the
    # postflight, so clear the quarantine flag before registering the daemon.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Noo-Noo.app"],
                   sudo: false
    system_command "#{appdir}/Noo-Noo.app/Contents/Resources/bin/noo-noo",
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
