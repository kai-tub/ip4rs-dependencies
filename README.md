# IP4RS Dependencies

> Dependencies for the IP4RS course.

The repository uses `micromamba` under the hood and provides some automations via a `justfile`
(see [just documentation for more information](https://github.com/casey/just)).
Previously, a `Docker Image` was used as the single source of truth,
but we are moving away from it as it provides little benefit over the
_direct_ installation via `micromamba`. `micromamba` should be prefered if possible and will be used
as the baseline to evaluate the homeworks.

<!-- Only MacOS users with an ARM chip (`M1/M2`) _must_ use `docker` to ensure that
they install the identical libraries and that all of them are available. -->
Windows users are recommended to install `micromamba` directly via
[the Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install) due
to missing support of Windows libraries for some dependencies.

## Installation

### Installing locally

1. Install [just](https://github.com/casey/just)
2. Move to the dependency directory and run `just install_env_<PLATFORM>`
3. Wait for the command to finish; might take up to 10min for downloading & unpacking
4. Start `jupyter lab` (`just jupyter`) and select the `ip4rs` kernel

### Running over Google Colab
If you _need_ a GPU, you _have_ to select the GPU instance before proceeding!
Note that you may not get access to a GPU instance as it is a _free_ service.

To reproduce our environment on Google Colab as closely as possible, we rely on
[condacolab](https://github.com/conda-incubator/condacolab) to install our
conda dependencies:

Add these cells to the _top_ of the notebook:
```
!pip install -q condacolab
import condacolab
condacolab.install()
```

colab "crashes" and restarts; this is expected.
Now we can install our dependencies as follows:

```
import condacolab
condacolab.check()

!curl https://raw.githubusercontent.com/kai-tub/ip4rs-dependencies/main/conda-linux-64.lock.yml >> lock.yml
!mamba env update -n base -f lock.yml
```

It will take ~7min to complete and after that you can start programming!

## Common issues

A few notes about common issues that we have seen before:
- Unhelpful error messages during installation about _permission issues_
  - Potentially full disk, ensure that at _least_ 20GB of free storage is available
- Cannot access `juypter lab` with given URL (404 not found)
  - Check that the correct `port` is used (especially when using `docker` with `-p` option)
  - If running WSL: Remote `localhost` in URL with `0.0.0.0` in browser
- Google Colab not showing `tqdm` progress or any `stderr`
  - No solution exists as Google Colab doesn't show `stderr` and due to this issue
  the default `tqdm` output doesn't work either
- Google Colab not showing `tqdm.notebook` output
  - In the _default_ environment Google Colab works, but when installing the environment
  via the conda-hack, there are issues with the Javascript/Front-end rendering engine; use
  use `tqdm.rich` instead


## Maintenance

### Adding new dependencies
- Add the new libraries to the [environment.yml](./environment.yml) file and run `just update_locks`

### Testing reproducible version
It may happen that a (transitive) dependency is pulled from `conda-forge`
(or any other conda channel) during the semester.
To fix it, simply update/regenerate the lock files!
The base `environment.yml` file is not that restrictive and it should be easy
to fix the issue by checking other available options during the resolve phase.

<!--As a result, the `docker build` and the direct installation via the `lock.yml`
file will fail, as `micromamba` won't be able to _find_ the pulled library.
To fix this, one can directly [update the dependencies](#adding-new-dependencies)
or use the `relaxed_lock.yml` file in the mean-time.
-->

Either way, after installing different library version, all source notebooks have
to be re-evaluated!

