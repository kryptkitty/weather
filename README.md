# `weather`

A nix flake for showing the weather.

Also a nix flake for showing how to make a shell script into nix flake that can be run directly.

## Usage

After [configuring your nix install to work with flakes][EnableFlakes]:

```bash
nix run github:kryptkitty/weather#
```

or

```bash
nix run github:kryptkitty/weather#grab-me-some-weather
```

or, if you don't have nix and don't know if you want it yet, here's a docker command that will do the same

```bash
docker run -ti nixos/nix nix run github:kryptkitty/weather# --extra-experimental-features nix-command --extra-experimental-features flakes
```


[EnableFlakes]: https://nixos.wiki/wiki/Flakes#Enable_flakes
