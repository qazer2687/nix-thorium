{
  description = "Thorium using Nix Flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = {
    self,
    nixpkgs,
    ...
  }: {
    packages.aarch64-linux = {
      thorium = let
        pkgs = import nixpkgs {system = "aarch64-linux";};
        pname = "thorium";
        version = "128.0.6613.194";
        src = pkgs.fetchurl {
          url = "https://github.com/Alex313031/Thorium-Raspi/releases/download/M128.0.6613.194/Thorium_Browser_128.0.6613.194_arm64.AppImage";
          sha256 = "sha256-eSPr0Shp9Mn9HlySlRu6hxtvqbNfKzsot5DX18L3Kg8=";
        };
        appimageContents = pkgs.appimageTools.extractType2 {
          inherit pname version src;
        };
      in
        pkgs.appimageTools.wrapType2 {
          inherit pname version src;
          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/thorium-browser.desktop $out/share/applications/thorium-browser.desktop
            install -m 444 -D ${appimageContents}/thorium.png $out/share/icons/hicolor/512x512/apps/thorium.png
            substituteInPlace $out/share/applications/thorium-browser.desktop \
            --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
          '';
        };
      default = self.packages.aarch64-linux.thorium;
    };
    apps.aarch64-linux = {
      thorium = {
        type = "app";
        program = "${self.packages.aarch64-linux.thorium}/bin/thorium";
      };
      default = self.apps.aarch64-linux.thorium;
    };
  };
}