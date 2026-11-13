{ inputs, lib, ... }:
{
  flake.nixosModules.pi =
    { pkgs, ... }:
    let
      # Realise the browser and SDK during the system build, not during a test.
      android = (pkgs.androidenv.override { licenseAccepted = true; }).composeAndroidPackages {
        platformVersions = [ "35" ];
        buildToolsVersions = [ "35.0.0" ];
        includeEmulator = true;
        includeSystemImages = true;
        systemImageTypes = [ "google_apis" ];
        abiVersions = [ "x86_64" ];
        includeNDK = false;
        includeSources = false;
      };
      sdk = "${android.androidsdk}/libexec/android-sdk";
      devTools = [
        pkgs.nodejs_24
        pkgs.pnpm
        pkgs.chromium
        pkgs.chromedriver
        pkgs.xorg-server # Xvfb for pi-browser's default headed mode.
        pkgs.xauth
        pkgs.android-tools
        android.androidsdk
        pkgs.jdk17
        pkgs.gnutar
        pkgs.unzip
        pkgs.zip
        pkgs.gnumake
        pkgs.gcc
        pkgs.pkg-config
        pkgs.typst
      ];
      androidAvd = pkgs.writeShellApplication {
        name = "pi-android-avd";
        runtimeInputs = [ android.androidsdk pkgs.jdk17 ];
        text = ''
          export ANDROID_HOME=${sdk}
          export ANDROID_SDK_ROOT=${sdk}
          export JAVA_HOME=${pkgs.jdk17}
          export ANDROID_USER_HOME="$HOME/.android"
          export ANDROID_AVD_HOME="$HOME/.android/avd"
          mkdir -p "$ANDROID_AVD_HOME"
          name="''${1:-pi-api35}"
          if [[ ! -f "$ANDROID_AVD_HOME/$name.ini" ]]; then
            ${android.androidsdk}/bin/avdmanager create avd \
              --name "$name" --package 'system-images;android-35;google_apis;x86_64' \
              --device pixel_6 <<< no
          fi
          echo "Created/available: $name"
          echo "Start: emulator -avd $name -no-window -no-audio -gpu swiftshader_indirect"
        '';
      };
      devCheck = pkgs.writeShellApplication {
        name = "pi-dev-check";
        runtimeInputs = devTools;
        text = builtins.readFile ./dev-check.sh;
      };
    in
    {
      imports = [ inputs.pi.nixosModules.default ];

      # Current NixOS/systemd supplies Android USB uaccess rules automatically.
      # KVM still needs host group membership; jail mounts cannot grant it.
      users.users.abhi.extraGroups = [ "kvm" ];
      # environment.systemPackages = devTools ++ [ androidAvd devCheck ];
      environment.sessionVariables = {
        "SEARXNG_URL" = "https://searxng.home.abhirath.net";
      };
      programs.pi.coding-agent = {
        enable = true;

        skills =
          let
            baseDir = ./skills;

            folderPaths = lib.mapAttrsToList (name: type: baseDir + "/${name}") (
              lib.filterAttrs (name: type: type == "directory") (builtins.readDir baseDir)
            );
          in
          folderPaths;

        themes = [ ./kanso.json ];
        extensions = [
          ./extensions/header.ts
          ./extensions/ask-question.ts
          ./extensions/bash-guard
          ./extensions/prompt-snippets
        ];
        rules = ''
          You operate in my NixOS development environment.

          - Inspect existing code and conventions before changing anything.
          - Prefer simple, focused solutions; avoid unnecessary dependencies and unrelated refactoring.
          - Work autonomously on reversible implementation decisions.
          - Ask when requirements are materially ambiguous or a decision involves major architecture, significant dependencies, or destructive changes.
          - Run pi-dev-check before visual testing. Node.js 24, npm, pnpm, Chromium, chromedriver, Xvfb, ADB, and an Android 35 SDK/image are preinstalled; do not download Puppeteer/Playwright browsers or fetch an on-demand Nix browser closure.
          - Use PI_BROWSER_EXECUTABLE / PUPPETEER_EXECUTABLE_PATH for browser automation. With Playwright/Patchright, pass process.env.PI_BROWSER_EXECUTABLE as executablePath explicitly; do not assume a bundled browser works on NixOS.
          - The browser tool intentionally blocks localhost/private networks. For local app tests use Chromium's CLI or project-local Playwright/Puppeteer with the installed executable, not the browser tool. Do not disable its network protections.
          - For Android, check adb devices -l, emulator -list-avds, and /dev/kvm first. pi-android-avd creates a reusable AVD from the preinstalled image. Ask before interacting with a physical device or wiping existing emulator data. Never claim native visual tests ran without a connected device or running emulator.
          - iOS simulators do not run on Linux. Request user screenshots or a Mac/iOS-capable environment for iOS visual testing.
          - Verify changes with relevant checks and tests. Investigate failures.
          - Be concise. Report outcomes, blockers, and important tradeoffs.
        '';
        settings = {
          defaultProvider = "openai-codex";
          packages = [
            "npm:@blazer2k/searxng-suite@0.2.3"
            "npm:@tintinweb/pi-subagents@0.19.0"
            "npm:@kvidzibo/pi-browser@0.1.0"
          ];
        };
        # ---------------------------------------------------------------------
        # Bubblewrap jail
        # ---------------------------------------------------------------------

        jail = {
          enable = true;

          permissions =
            combinators: with combinators; [
              # Allow network access.
              #
              # Needed for normal agent usage, package registries, GitHub,
              # documentation, etc.
              network

              # The jail does not see the host's /etc/nix/nix.conf. Match its
              # experimental features without exposing the host configuration.
              (set-env "NIX_CONFIG" "experimental-features = nix-command flakes ca-derivations")

              # Make the directory from which `pi` is launched writable.
              #
              # This is what makes the git-workspace-per-agent design work:
              #
              #   cd ~/agents/oculog/auth
              #   pi
              #
              # Only that workspace becomes the working directory.
              mount-cwd

              # Display sockets are optional so headless/WSL sessions still work.
              # X11 access is powerful; prefer Xvfb for unattended browsing.
              (try-fwd-env "WAYLAND_DISPLAY")
              (try-fwd-env "XDG_RUNTIME_DIR")
              (try-fwd-env "XDG_SESSION_TYPE")
              (add-runtime ''
                if [[ -n "''${WAYLAND_DISPLAY:-}" && -n "''${XDG_RUNTIME_DIR:-}" ]]; then
                  display_path="$WAYLAND_DISPLAY"
                  [[ "$display_path" = /* ]] || display_path="$XDG_RUNTIME_DIR/$display_path"
                  RUNTIME_ARGS+=(--ro-bind-try "$display_path" "$display_path")
                fi
              '')
              (runtime-deep-ro-bind "/etc/fonts")
              (try-fwd-env "DISPLAY")
              (try-fwd-env "XAUTHORITY")
              (try-readwrite "/tmp/.X11-unix")
              (try-readonly (noescape "\"\${XAUTHORITY:-$HOME/.Xauthority}\""))

              # Android needs device mounts, not ordinary file binds. Optional
              # on WSL/headless machines; host udev/group permissions still apply.
              (unsafe-add-raw-args "--dev-bind-try /dev/kvm /dev/kvm")
              (unsafe-add-raw-args "--dev-bind-try /dev/bus/usb /dev/bus/usb")
              (try-readonly "/sys/bus/usb")
              (try-readonly "/sys/devices")

              # Persist only development state, not the entire real home.
              (add-runtime ''
                mkdir -p ~/.android/avd ~/.cache/pi-dev ~/.cache/pnpm ~/.local/share/pnpm ~/.gradle
              '')
              (readwrite (noescape "~/.android"))
              (readwrite (noescape "~/.cache/pi-dev"))
              (readwrite (noescape "~/.cache/pnpm"))
              (readwrite (noescape "~/.local/share/pnpm"))
              (readwrite (noescape "~/.gradle"))
              (set-env "XDG_CACHE_HOME" (noescape "\"$HOME/.cache/pi-dev\""))
              (set-env "PNPM_HOME" (noescape "\"$HOME/.local/share/pnpm\""))
              (set-env "ANDROID_HOME" sdk)
              (set-env "ANDROID_SDK_ROOT" sdk)
              (set-env "ANDROID_USER_HOME" (noescape "\"$HOME/.android\""))
              (set-env "ANDROID_AVD_HOME" (noescape "\"$HOME/.android/avd\""))
              (set-env "JAVA_HOME" "${pkgs.jdk17}")
              (set-env "PI_BROWSER_EXECUTABLE" "${pkgs.chromium}/bin/chromium")
              (set-env "PUPPETEER_EXECUTABLE_PATH" "${pkgs.chromium}/bin/chromium")
              (set-env "PUPPETEER_SKIP_DOWNLOAD" "true")
              (set-env "PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD" "1")

              # Explicitly expose development tools.
              #
              # add-pkg-deps includes the package runtime closure and adds
              # its bin/ directory to PATH inside the jail.
              (add-pkg-deps (devTools ++ [ androidAvd devCheck ] ++ [
                pkgs.git

                pkgs.ripgrep
                pkgs.fd
                pkgs.jq
                pkgs.curl

                pkgs.coreutils
                pkgs.findutils
                pkgs.diffutils
                pkgs.gnugrep
                pkgs.gnused
                pkgs.gawk

                pkgs.nix
                pkgs.bash
                pkgs.uv
                pkgs.python3
              ]))

              # Useful so git/git know your identity and preferences.
              #
              # Read-only: Pi cannot modify the host configuration.
              (try-readonly (noescape "~/.gitconfig"))
            ];
        };
      };
    };
}
