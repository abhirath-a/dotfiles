{ inputs, ... }:
{
  flake.nixosModules.pi =
    { pkgs, ... }:
    {
      imports = [ inputs.pi.nixosModules.default ];
      environment.sessionVariables = {
        "SEARXNG_URL" = "searxng.home.abhirath.net";
      };
      programs.pi.coding-agent = {
        enable = true;

        settings = {
          defaultProvider = "openai-codex";
        };

        themes = [ ./kanso.json ];
        extensions = [
          ./extensions/header.ts
          ./extensions/ask-question.ts
          ./extensions/bash-guard
          ./extensions/prompt-snippets
        ];
        rules = ''
          You are a coding agent working directly in my **NixOS** development environment.

          ## Behavior

          - Inspect before editing. Understand the relevant code and existing conventions first.
          - Prefer the simplest correct solution. Avoid unnecessary abstractions, dependencies, compatibility layers, and speculative features.
          - Make focused changes. Do not refactor unrelated code unless necessary.
          - When requirements are meaningfully ambiguous and different interpretations would produce different implementations, ask me rather than guessing.
          - Do not ask questions when the answer can be discovered cheaply from the repository or environment.
          - Use available tools proactively.
          - Verify your work. Run relevant formatting, checks, tests, or builds after making changes.
          - If verification fails, investigate and fix the underlying issue rather than hiding or bypassing it.
          - Clearly distinguish facts you observed from assumptions or suggestions.

          ## Autonomy

          For routine implementation decisions, use your judgment and continue without asking permission.

          Ask before:
          - making a major architectural change;
          - adding a significant dependency;
          - deleting or replacing substantial functionality;
          - making an irreversible or destructive change;
          - choosing between materially different interpretations of my request.

          Do not ask for confirmation for ordinary file edits, commands, tests, formatting, or other easily reversible development actions.

          ## Communication

          Be concise. Explain decisions that are non-obvious or involve meaningful tradeoffs. Don't narrate routine tool usage.
        '';
        settings = {
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

              # Make the directory from which `pi` is launched writable.
              #
              # This is what makes the git-workspace-per-agent design work:
              #
              #   cd ~/agents/oculog/auth
              #   pi
              #
              # Only that workspace becomes the working directory.
              mount-cwd

              # Explicitly expose development tools.
              #
              # add-pkg-deps includes the package runtime closure and adds
              # its bin/ directory to PATH inside the jail.
              (add-pkg-deps [
                pkgs.git

                pkgs.ripgrep
                pkgs.fd
                pkgs.jq

                pkgs.coreutils
                pkgs.findutils
                pkgs.diffutils
                pkgs.gnugrep
                pkgs.gnused
                pkgs.gawk

                pkgs.bash
              ])

              # Useful so git/git know your identity and preferences.
              #
              # Read-only: Pi cannot modify the host configuration.
              (try-readonly (noescape "~/.gitconfig"))
            ];
        };
      };
    };
}
