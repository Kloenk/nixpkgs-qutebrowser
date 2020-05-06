{
  edition = 201909;

  description = "qutebrowser based on Qt5.14";

  inputs.nixpkgs = {
    type = "github";
    owner = "nixos";
    repo = "nixpkgs";
    rev = "fce7562cf46727fdaf801b232116bc9ce0512049";
  };

  outputs = inputs@{ self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        });
    in {
      overlay = import ./overlay.nix;

      packages = forAllSystems (system: nixpkgsFor.${system});
      defaultPackage =
        forAllSystems (system: self.packages.${system}.qutebrowser);

      apps = forAllSystems (system: {
        qutebrowser = {
          type = "app";
          program = "${self.packages.${system}.qutebrowser}/bin/qutebrowser";
        };
      });
      defaultApp = forAllSystems (system: self.apps.${system}.qutebrowser);
    };
}
