{
  description = "show thy weather";

  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = ({ self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: { packages = 
    let
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };

    in rec {
      default = grab-me-some-weather;
      grab-me-some-weather = pkgs.writeShellApplication {
        name = "grab-me-some-weather";
        runtimeInputs = with pkgs; [ curl less ];

        text = ''
          curl -s wttr.in | less -r
        '';
      };
    }
  ;}));
}
