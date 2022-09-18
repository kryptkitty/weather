# to use this file as a template, search for EDIT and modify the associated variable as needed

{
  # EDIT: package/flake description to be shared
  description = "use the @PACKAGE@ flake";

  # EDIT: set desired nixpkgs release to track
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  # EDIT: remove or modify this sample of using a script combining other flakes
  #       the string below contains newlines to defeat the automated templating
  #       and do not need to be preserved in a new flake.  \h = h, \k = k
  inputs.upstreamWeatherFlake.url = "github:kryptkitty/weather";

  outputs = ({ self, nixpkgs, flake-utils, upstreamWeatherFlake }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system;
	  config.allowUnfree = true;  # EDIT: allow unfree packages?
	};
        upstreamWeatherPackage = upstreamWeatherFlake.outputs.packages."${system}"."weather";

        # EDIT: bring in all the packages we're exposing
        packages = {
          @PACKAGE@ = pkgs.callPackage ./@PACKAGE@.nix { inherit pkgs; };
          
	  # EDIT: remove or modify this sample of using a script combining other flakes
	  upstreamWeather = pkgs.callPackage ./other-flake-example.nix {
	    inherit pkgs upstreamWeatherPackage;
	  };
        };

        # EDIT: set the default package when running the flake as `nix run repo#`
        defaultPackage = packages.@PACKAGE@;
      in { inherit packages defaultPackage; }
    ))
      // { templates.default = {
	  path = ./template;
	  description = "make your own executable @PACKAGE@ (or other shell script) flake";
	  welcomeText = ''
	    Your new flake is ready to be initialized.

            There is a simple init script which will do this for you.  It will
	    change the files in the same way as substituteAllInPlace after
	    asking for the values.  You are encouraged to use the script after
	    evaluating it with eyeballs.

                bash ./init-template.sh
	    
	    When this script is complete, it will remove itself, leaving you
	    with a new flake, ready to go.
	  '';
      };}
    );
}
