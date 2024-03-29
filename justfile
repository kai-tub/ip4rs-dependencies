# allow docker image to overwrite the environment
env-name := env_var_or_default("MAMBA_ENV_NAME", "ip4rs")
image-name := "ip4rs"
env := "environment.yml"

env-cmd := "micromamba run --name=" + env-name
set dotenv-load := false

# Install environment from lock.yml
# install: install_base install_locked_python_deps install_ipykernel

# Install base dependencies
install_base:
	micromamba create --yes --name locker --channel=conda-forge conda-lock

# Generate global lock
lock:
	rm conda-lock.yml # ensure that fresh lock is created
	micromamba run --name locker conda-lock lock --file {{env}}

render_locks:
	micromamba run --name locker conda-lock render
	micromamba run --name locker conda-lock render --kind env

update_locks: install_base lock render_locks

install_env target:
	micromamba create --yes --name {{env-name}} --file conda-{{target}}.lock

install_env_linux: (install_env "linux-64")

install_env_osx_intel: (install_env "osx-64")

install_env_osx_arm64: (install_env "osx-arm64")

# install_env

# Install from lock file (not created with explicit!)
# install_locked_python_deps:
# 	micromamba create --yes --name {{env-name}} --file lock.yml

# Install from general environment.yml
# install_python_deps:
# 	micromamba create --yes --name {{env-name}} --file environment.yml

# Install dependencies from environment.yml and export to lock.yml
# update_locks: install_python_deps
# 	micromamba env --name {{env-name}} export > lock.yml
# 	micromamba env export --no-build --no-md5 > relaxed_lock.yml

# Install the IPython Kernel for the new environment
# install_ipykernel:
# 	{{env-cmd}} python -m ipykernel install --user --name {{env-name}}
	
# Run the jupyter lab environment via all interfaces by default
jupyter:
	{{env-cmd}} jupyter lab --ip=0.0.0.0

# Build docker file (podman style)
docker-build:
	docker build --format=docker {{justfile_directory()}}/ -t {{image-name}}

# Run ip4rs docker file with port forwarding & volume mounting of invocing path
docker-jupyter:
	docker run -p=8888:8888 --volume={{invocation_directory()}}/:/home/mambauser/workspace {{image-name}}:latest

test:
	#!/usr/bin/env bash
	set -exuo pipefail
	! test -e tests/touched
	docker build --format=docker . -t ip4rs
	image=$(docker run --volume="$PWD":/home/mambauser/workspace -d ip4rs:latest)
	docker exec $image micromamba run --name=base jupyter execute tests/test.ipynb
	docker kill $image
	rm tests/touched
	! test -e tests/touched

# Run CMDS in the generated environment
run +CMDS:
	{{env-cmd}} {{CMDS}}
