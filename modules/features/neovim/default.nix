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

      environment.systemPackages = [
        pkgs.fzf
        pkgs.fd
        pkgs.lua-language-server
        pkgs.nil
        pkgs.gopls
        pkgs.ripgrep
        pkgs.rust-analyzer
        pkgs.marksman
        pkgs.astro-language-server
        pkgs.elixir-ls
        pkgs.typescript-go
        pkgs.ty
        pkgs.tinymist
        pkgs.typstyle
        pkgs.svelte-language-server
        pkgs.tailwindcss-language-server
      ];
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
          typescript-go
          ty
          tinymist
          svelte-language-server
          tailwindcss-language-server
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
