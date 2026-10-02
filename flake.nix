{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    libs = with pkgs; [
      fontconfig
      freetype
      wayland
      libxkbcommon
    ];
  in {
    devShells."x86_64-linux".default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        pkg-config cargo rustc rustfmt clippy rust-analyzer
      ];
      buildInputs = libs;
      env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libs;
    };
  };
}
