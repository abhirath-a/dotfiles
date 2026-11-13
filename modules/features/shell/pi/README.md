# Pi development runtime (NixOS)

This module installs the development tools both on the host and in pi's
bubblewrap jail. The locked Nixpkgs input pins their versions. No application
package or lockfile changes are needed.

## Activate before starting tests

From the dotfiles directory, on the actual NixOS host:

```sh
sudo nixos-rebuild switch --flake .#gtx-nix
```

The first build downloads Chromium, ChromeDriver, Node 24/npm, pnpm, Xvfb,
JDK 17, Android tools, and an Android 35 Google APIs x86_64 system image.
**Budget several GiB and finish the build before testing.** The Android
composition explicitly accepts Google's SDK licenses. Its SDK is immutable;
change the composition and rebuild instead of using sdkmanager to install into it.

Log out and back in to obtain the `kvm` group, then start a **new pi process**
from the application workspace. `/reload` cannot change a running jail's mounts,
PATH, or group membership. Existing pi configuration/state is retained.

```sh
pi-dev-check
pi-dev-check --browser /tmp/pi-browser-smoke.png
pi-dev-check --android
```

The browser check launches real headless Chromium and writes a screenshot. It
does not download a browser or disable Chromium sandboxing. Run checks inside pi
as well as outside it when investigating a permission problem. Failures must be
fixed or reported; an executable being on PATH is not proof a visual test ran.

## Browsers

- pi-browser discovers `PI_BROWSER_EXECUTABLE` and uses the installed Xvfb by
  default. `/browser mode host` or `/browser login` can use the host display.
- Puppeteer uses `PUPPETEER_EXECUTABLE_PATH`; downloads are disabled. For
  Playwright/Patchright, pass `executablePath: process.env.PI_BROWSER_EXECUTABLE`
  explicitly. A project's automation library remains its own dependency.
- pi-browser deliberately blocks localhost/private URLs. Test local apps using
  Chromium CLI or the project's automation library with the Nix Chromium path.
  Do not remove the browser tool's network gate.
- Screenshots can also be taken directly:
  `chromium --headless --disable-dev-shm-usage --screenshot=/tmp/app.png http://127.0.0.1:3000`.
- No `--no-sandbox` workaround is enabled. If Chromium cannot start, inspect its
  stderr and host user-namespace policy instead of downloading another binary.

## Android

```sh
pi-android-avd                         # create pi-api35 once; never overwrites it
emulator -avd pi-api35 -no-window -no-audio -gpu swiftshader_indirect
# In another terminal/tool call, after Android finishes booting:
adb devices -l
adb -s emulator-5554 shell getprop sys.boot_completed
adb -s emulator-5554 exec-out screencap -p > /tmp/android.png
```

Omit `-no-window` for an interactive emulator. Software rendering avoids requiring
GPU device/driver access in the jail; KVM still accelerates the CPU. Persisted
AVDs and ADB keys live in `~/.android`. Ask before using a physical device or
wiping an existing AVD. Select an explicit ADB serial when multiple targets exist.

The jail exposes `/dev/kvm` and `/dev/bus/usb` when present. Current NixOS/systemd
supplies Android USB uaccess rules; `programs.adb.enable` has been removed in the
pinned Nixpkgs. Physical USB access still requires an active local user session,
USB debugging, and accepting the device's authorization prompt. KVM requires
hardware virtualization and fresh `kvm` group membership. WSL may require USB
forwarding/nested virtualization; configuration cannot manufacture those features.

iOS simulators are unavailable on Linux: use a Mac/iOS-capable environment or
user-provided screenshots.

## Access boundaries

The workspace, `~/.pi/agent`, Android state, Gradle state, and dedicated development
caches are writable. The entire home directory, SSH keys, browser profiles, and
host configuration are **not** exposed. Temporary files in the jail stay isolated.
Destructive-command safeguards remain enabled.

Host Wayland/X11 sockets and the X authorization file are exposed when available
for interactive windows. **X11 is not a security boundary**: X11 clients can
observe/control other clients. Prefer Xvfb for unattended browsing. USB access and
the shared host network also confer real device/service control; use trusted
extensions and do not assume the jail protects connected devices from pi.

Old `/tmp/oculog-browser` and `~/.cache/puppeteer` artifacts are not deleted.
