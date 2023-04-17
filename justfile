# allow docker image to overwrite the environment
env-name := env_var_or_default("MAMBA_ENV_NAME", "ip4rs")
image-name := "ip4rs"

env-cmd := "micromamba run --name=" + env-name
set dotenv-load := false

# Install environment from lock.yml
install: install_locked_python_deps install_ipykernel

# Install from lock file (not created with explicit!)
install_locked_python_deps:
	micromamba create --yes --name {{env-name}} --file lock.yml

# Install from general environment.yml
install_python_deps:
	micromamba create --yes --name {{env-name}} --file environment.yml

# Install dependencies from environment.yml and export to lock.yml
update_locks: install_python_deps
	micromamba env --name {{env-name}} export > lock.yml
	micromamba env export --no-build --no-md5 > relaxed_lock.yml

# Install the IPython Kernel for the new environment
install_ipykernel:
	{{env-cmd}} python -m ipykernel install --user --name {{env-name}}
	
# Run the jupyter lab environment via all interfaces by default
jupyter:
	{{env-cmd}} jupyter lab --ip=0.0.0.0

# Build docker file
docker-build:
	docker build {{justfile_directory()}}/ -t {{image-name}}

# Run ip4rs docker file with port forwarding
docker-jupyter:
	docker run -p=8888 {{image-name}}:latest

# Run CMDS in the generated environment
run +CMDS:
	{{env-cmd}} {{CMDS}}
