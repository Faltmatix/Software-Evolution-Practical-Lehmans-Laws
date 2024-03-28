{
  description = "NixOS config";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      flake-utils.url = "github:numtide/flake-utils";

  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem 
      (system: 
        let
          pkgs = import nixpkgs { 
              inherit system; 
              config = { allowUnfree = true; cudaSupport = false; };
              };
        in 
        with pkgs;
        {
              devShells.default = mkShell rec {
                buildInputs = [ 
		    python311
                    stdenv.cc.cc.lib
		    gcc
		    cmake
                ];
                LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}:${pkgs.stdenv.cc.cc.lib}/lib";
        };
        });
}
