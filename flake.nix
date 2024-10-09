{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?nixpkgs-unstable";
    naersk.url = "github:nix-community/naersk";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, naersk, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        naersk' = pkgs.callPackage naersk { };
      in
      rec {
        packages = rec {
          binsider = naersk'.buildPackage {
            name = "binsider";
            src = ./.;
            release = false;

            meta = with pkgs.lib; {
              description = "Analyze ELF binaries like a boss";
              homepage = "https://binsider.dev/";
              license = [ licenses.mit licenses.asl20 ];
            };
          };
          default = binsider;
        };
        checks.check = packages.binsider;
      }
    );

}
