# this is an example of composing flakes using a shell script.  it is
# unimportant that there's just one flake being "composed" into a wrapper or
# that the external flake is _this_ flake being used to call itself.
#
# in the latter case, it's not even the same flake, actually!  the external
# flake is actually the current HEAD on github of the same codebase but this is
# what really sets nix and flakes apart -- the two flakes in question are
# different flakes built from the same (or similar) codebase.
#
# when this sample is used from a flake made from this repo as a template,
# upstreamWeather _will continue to work_.  Magic!

# because this file is being called via nixpkgs.callPackage, it should return a
# derivation containing the application to be run which should be located in
# bin/upstreamWeather or bin/whatever where "whatever" is the name of the
# package in the flake.  If the name in bin/ does not match the name in
# outputs.*.packages of flake.nix, then nix run .#whatever won't function
# properly.  Achieving these requirements is most easily accomplished using
# nixpkgs.writeShellApplication which is used below.

# you will need to pass in anything you need from the external flake.
{ pkgs, upstreamWeatherPackage }:

pkgs.writeShellApplication {
  name = "upstreamWeather";
  runtimeInputs = [ upstreamWeatherPackage pkgs.python310 ];
  text = ''
    echo running weather in 3 seconds
    echo sleeping with python l3l
    python -c 'import time;time.sleep(2.8);print("getting weather");time.sleep(.2)'
    echo "running $(which weather)"
    weather
    echo "hope you have a beautiful day."
    echo "or don't."
    echo "whatever."
  '';
}
