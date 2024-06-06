{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let 
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = 
        pkgs.mkShell {
          buildInputs = with pkgs; [
            elixir
            elixir-ls
            inotify-tools
          ];
          FILESYNC_LOCAL="user@127.0.0.1";
          FILESYNC_LOCATION="/home/user/playground/";
          FILESYNC_COOKIE="cookie";
          shellHook = ''
            exec zsh
          '';
        };
    };
}

