{ sources ? import ./nix/sources.nix }:

let pkgs = import sources.nixpkgs { overlays = [ (import ./overlay.nix) ]; };

in pkgs.qutebrowser
