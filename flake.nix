{
  description = "Godot with Spacemouse support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          default = self.packages.${system}.godot-wrapped;

          godot-wrapped = pkgs.symlinkJoin {
            name = "godot_4_3-wrapped";
            paths = [
              (pkgs.writeShellScriptBin "godot_4_3" ''
                export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH
                exec ${pkgs.godot_4_3}/bin/godot "$@"
              '')
            ];
            postBuild = ''
              mkdir -p $out/share/applications

              # Copy the desktop file from the original package
              cp ${pkgs.godot_4_3}/share/applications/*.desktop $out/share/applications/

              # Update the Exec line in the desktop file to point to our wrapped script
              sed -i "s|Exec=.*|Exec=$out/bin/godot_4_3|" $out/share/applications/*.desktop
            '';
          };

          spacemouse-udev-rules = pkgs.runCommand "10-spacemouse-rules" {} ''
            mkdir -p $out/lib/udev/rules.d
            cat > $out/lib/udev/rules.d/10-spacemouse.rules << EOF
            # Spacenav 3D mouse rules
            KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c626", TAG+="uaccess"
            KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c635", TAG+="uaccess"
            KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c632", TAG+="uaccess"
            KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c62b", TAG+="uaccess"
            KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c62e", TAG+="uaccess"
            KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c652", TAG+="uaccess"
            KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c629", TAG+="uaccess"
            KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c63a", TAG+="uaccess"
            EOF
          '';
        };
      }
    ) // {
      nixosModules.default = { config, pkgs, lib, ... }: {
        imports = [];

        environment.systemPackages = with self.packages.${pkgs.system}; [
          godot-wrapped
          pkgs.godot_4_3
        ];

        # Install build depends here for any programs not managed by nix (eg: steam-godot)
        programs.nix-ld.enable = true;
        programs.nix-ld.libraries = with pkgs; [
          hidapi # needed for spacemouse in godot
        ];

        # Create a custom package for high-priority spacemouse udev rules
        services.udev.packages = [
          self.packages.${pkgs.system}.spacemouse-udev-rules
        ];
      };
    };
}
