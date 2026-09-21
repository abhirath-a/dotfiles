{ inputs, ... }:
{
  flake.nixosModules.pi =
    { pkgs, ... }:
    {
      imports = [ inputs.pi.nixosModules.default ];
      programs.pi.coding-agent = {
        enable = true;

        settings = {
          defaultProvider = "openai-codex";
        };

        themes = [ ./kanso.json ];
        extensions = [
          ./extensions/header.ts
          ./extensions/ask-question.ts
        ];
        rules = ''
          # Version control

          Use Git (`git`) for version-control operations in repositories
          managed by git.

          Keep changes small and focused.

          Inspect the final diff before finishing.

          Never push, force-push, delete bookmarks, or perform destructive
          version-control operations unless explicitly requested.

          # Development

          Follow the conventions already present in the repository.

          Use tools provided by the development environment.

          Run relevant formatters, linters, type checks, and tests after
          making changes.

          Do not install dependencies globally.

          # Scope

          Work only inside the current project/workspace unless explicitly
          instructed otherwise.

          Do not inspect unrelated files, repositories, credentials, SSH
          keys, browser state, or other private data.

          Do not modify files unrelated to the task.
        '';

        jail = {
          enable = true;

          permissions =
            combinators: with combinators; [
              network
              mount-cwd
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

              (try-readonly (noescape "~/.gitconfig"))
            ];
        };
      };
    };
}
