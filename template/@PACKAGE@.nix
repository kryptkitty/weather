{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "@PACKAGE@";
  runtimeInputs = with pkgs; [ curl less ];

  text = ''
    curl -s wttr.in | less -r
  '';
}
