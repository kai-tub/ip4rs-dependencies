# IP4RS Dependencies

> Dependencies for the IP4RS course.

The repository uses `micromamba` under the hood and provides some automations via a `justfile`
(see [just documentation for more information](https://github.com/casey/just)).
Previously, a `Docker Image` was used as the single source of truth,
but we are moving away from it as it provides little benefit over the
_direct_ installation via `micromamba`. `micromamba` should be prefered if possible and will be used
as the baseline to evaluate the homeworks.

Only MacOS users with an ARM chip (`M1/M2`) _must_ use `docker` to ensure that
they install the identical libraries and that all of them are available.
Windows users are recommended to install `micromamba` directly via
[the Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install)
over the `docker`-based solution.

## Installation

### Installing locally

1. Install [just](https://github.com/casey/just)
2. Move to the dependency directory and run `just install`
3. Wait for the command to finish; might take up to 10min
4. Start `jupyter lab` (`just jupyter`) and select the `ip4rs` kernel

### Installing via docker

0. Install [docker](https://docs.docker.com/desktop/)
  - If using MacOS/Windows, we recommend using _Docker Desktop_
1. Install [just](https://github.com/casey/just)
2. Run `just docker-build` (may take up to 20min) or directly `docker build . -t ip4rs`
3. Run image with correct port, mounted volume (to persist files) to the workspace directory `/home/mambauser/workspace`: 
`docker run -p=8888:8888 --volume="$PWD":/home/mambauser/workspace ip4rs:latest`

## Common issues

A few notes about common issues that we have seen before:
- Unhelpful error messages during installation about _permission issues_
  - Potentially full disk, ensure that at _least_ 20GB of free storage is available
- Cannot access `juypter lab` with given URL (404 not found)
  - Check that the correct `port` is used (especially when using `docker` with `-p` option)
  - If running WSL: Remote `localhost` in URL with `0.0.0.0` in browser

## Maintenance

### Adding new dependencies
- Add the new libraries to the [environment.yml](./environment.yml) file and run `just update_locks`

### Testing reproducible version
It may happen that a (transitive) dependency is pulled from `conda-forge`
(or any other conda channel) during the semester.
As a result, the `docker build` and the direct installation via the `lock.yml`
file will fail, as `micromamba` won't be able to _find_ the pulled library.
To fix this, one can directly [update the dependencies](#adding-new-dependencies)
or use the `relaxed_lock.yml` file in the mean-time.

Either way, after installing different library version, all source notebooks have
to be re-evaluated!

