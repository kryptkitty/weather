# `weather`

A nix flake for showing the weather.

Also a nix flake for showing how to make a shell script into nix flake that can be run directly.

Also a nix flake that makes a templated version of itself.

## Usage

After [configuring your nix install to work with flakes][EnableFlakes]:

```bash
nix run github:kryptkitty/weather#
```

or

```bash
nix run github:kryptkitty/weather#weather
```

or, if you don't have nix and don't know if you want it yet, here's a docker
command that will do the same

```bash
docker run -ti nixos/nix \
    nix run github:kryptkitty/weather# \
        --extra-experimental-features nix-command \
	--extra-experimental-features flakes
```

## Template

To make a new flake based off of this one, use nix flake init with this flake
as the template:

```bash
nix flake init -t github:kryptkitty/weather
```

Then follow the directions!  You will be asked to run a setup script which
will initialize the flake's template data.  This will be described in the
template's welcomeText so give it a whirl.

### Template Maintenance

The template update system consists of a shell script in `bin/` called
`update-template.sh`.  This script will clone all the files except for a
handful that would be inappropriate into `template/`.  The files which are not
copied are the existing flake's `.git/`, `flake.lock`, `template/`,
`update-template.sh` and `*.template`.  Most of those make sense except for
`*.template` which is explained below.

#### Template-only files

Any files which exist _only_ in `template/` will remain there after running
`update-template.sh`.  This is used to present files only to a template rather
than to the example weather flake.

#### `*.template` overrides

This class of file is special because it will override its unadorned sibling.
This can be seen in `README.md` which has a sibling `README.md.template` to
use instead of the template flake's `README.md` which you are reading now.

Any file may be used this way but the file to override must exist next to the
`.template` version.  If there is no base file, the template file will not be
found.

Using a symlink to make the .template file point to the base file will make a
file which is unchanged by the @VARIABLE@ step but which also tracks the base
file automatically.

#### `init-template.sh` generation

This autogenerated file exists only in `template/` and will be replaced upon
every invocation of `update-template.sh`.

To make permanent changes to this file, the changes must be made in
`update-template.sh` near the end.

### Template Workflow

NOTE: in this section, `.` is the folder that holds `.git` for
`github:kryptkitty/weather`:

1) make desired changes
  * changes to `./template/init-template.sh` go in `./bin/update-template.sh`
  * changes to `./template/README.md` go in `./README.md.template`
  * changes to other files go into the respective file in `.`, (e.g., changes
    to `./template/flake.nix` go into `./flake.nix`)

2) run `update-template.sh`
  * take changes from the described places and bundle them up in template
  * convert constants such as the author's name into `@VARIABLES@` in all
    files within `./template/`.  This is used, for example, to create the
    copyright line in `./template/LICENSE` out of the same copyright line in
    `./LICENSE`

3) run `git add .`
  * this step is a must because of how flakes work.

4) test
  * there is no automated testing for this yet.  Feel free to contribute it.
    for now, here is my method:
    * ```bash
      cd "$HOME/src/github.com/kryptkitty"
      rm -rf testing-weather-template
      mkdir testing-weather-template
      cd testing-weather-template
      nix flake init -t ../weather
      bash init-template.sh
      # follow prompts
      nix run .#
      ```
  * Remember to spot check the files.  This is easily done at this stage (git
    it?  staged commit pun) using git:
    * ```bash
      git diff --cached
      ```

5) commit and push
  * there is currently no formal release process for this project.

## Input Flake Composition Sample

This repo contains a sample of wrapping an input flake (or flakes) with a
shell script which is used to compose them into customized behavior.  The
script uses python to sleep and communicate to also give an example of mixing
the composition of the input flake with a nixpkgs package.

It is recommended to template the repo to create an upstreamWeather package in
a new flake which does _not_ contain weather.  It may also be viewed in the
weather repo for a more exotic sample of loading the upstream in the flake
with the local copy and being able to use both at the same time.

The example is in `other-flake-example.nix` and `flake.nix` to a lesser
degree.  Instances of krypt\kitty and weat\her are noncanonical
representations of the same strings without a backslash.  This is used only to
defeat the templater in these instances because these are string literals
which must be passed unchanged to the fully instantiated flake based on the
template of this repo.


[EnableFlakes]: https://nixos.wiki/wiki/Flakes#Enable_flakes
