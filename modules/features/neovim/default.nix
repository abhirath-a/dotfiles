{ self, inputs, ... }:

{
  flake.nixosModules.nvim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.nvim;
      };

      environment.shellAliases = {
        vim = "nvim";
      };
    };
  perSystem =
    { pkgs, system, ... }:
    let
      nightlyPkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.neovim-nightly-overlay.overlays.default
          inputs.blink-cmp.overlays.default
        ];
      };
    in
    {
      packages.nvim = inputs.wrapper-modules.wrappers.neovim.wrap {
        pkgs = nightlyPkgs;

        settings = {
          config_directory = ./.;
          tssdk = ''${nightlyPkgs.typescript_5}/lib/node_modules/typescript/lib'';
        };
        runtimePkgs = with nightlyPkgs; [
          fzf
          fd
          ripgrep
          lua-language-server
          nil
          gopls
          rust-analyzer
          marksman
          astro-language-server
          elixir-ls
          typescript
          ty
          ruff
          tinymist
          svelte-language-server
          tailwindcss-language-server
          jdt-language-server
          clang-tools
          oxfmt
        ];

        specs = with pkgs.vimPlugins; {
          general = [
            nvim-treesitter.withAllGrammars
            fzf-lua
            blink-cmp
            vim-fugitive
            kanso-nvim
            oil-nvim
            typst-preview-nvim
            nvim-lspconfig
            friendly-snippets
          ];
        };
      };
    };

}
