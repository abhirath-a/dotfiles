# Installed as pi-dev-check by writeShellApplication.
failed=0
for cmd in node npm pnpm chromium chromedriver Xvfb adb emulator avdmanager java; do
  if command -v "$cmd"; then
    :
  else
    echo "Missing required tool: $cmd" >&2
    failed=1
  fi
done
(( failed == 0 )) || exit 1
node --version
npm --version
pnpm --version
chromium --version
chromedriver --version
adb version

case "${1:-}" in
  "")
    echo 'Tools found. Use --browser for a real screenshot smoke test; --android for device/KVM checks.'
    ;;
  --browser)
    output="${2:-$PWD/pi-browser-smoke.png}"
    profile="$(mktemp -d)"
    # Keep Chromium sandboxing enabled. Do not silently retry with --no-sandbox.
    chromium --headless --disable-dev-shm-usage --no-first-run \
      --user-data-dir="$profile" --screenshot="$output" --window-size=800,600 \
      'data:text/html,<html><body><h1>Nix Chromium smoke test</h1></body></html>'
    test -s "$output"
    echo "Screenshot: $output"
    echo "Temporary browser profile (not automatically deleted): $profile"
    ;;
  --android)
    if [[ -r /dev/kvm && -w /dev/kvm ]]; then
      echo 'KVM: accessible'
    else
      echo 'KVM: unavailable. Check virtualization/WSL support and log in again after adding the kvm group.' >&2
      failed=1
    fi
    emulator -accel-check || failed=1
    emulator -list-avds
    adb devices -l
    echo 'A physical device must have USB debugging enabled and approve this host key.'
    ;;
  *)
    echo 'Usage: pi-dev-check [--browser [screenshot.png] | --android]' >&2
    exit 2
    ;;
esac
exit "$failed"
