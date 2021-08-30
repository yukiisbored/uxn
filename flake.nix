{
  description = "An assembler and emulator for the Uxn stack-machine";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    with utils.lib; eachDefaultSystem(system:
      let
        pkgs = import nixpkgs { inherit system; };

        version = if self ? rev then self.rev else "dirty";
        uxn = pkgs.callPackage ./nix/uxn.nix { inherit version; };
      in rec {
        packages = { inherit uxn; };
        defaultPackage = uxn;

        apps = builtins.foldl' (set: name:
          set // { "${name}" = mkApp { inherit name; drv = uxn; }; })
          {} ["uxnemu" "uxnasm" "uxncli"];
        defaultApp = apps.uxnemu;
      });
}
