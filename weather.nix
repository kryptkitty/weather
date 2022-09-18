{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "weather";
  runtimeInputs = with pkgs; [ curl less ];

  text = ''
    curl -s wttr.in | less -r
  '';
}
