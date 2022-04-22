
# allow docker image to overwrite the environment
env-name := env_var_or_default("MAMBA_ENV_NAME", "ip4rs")

env-cmd := "mamba run --name " + env-name
set dotenv-load := false

install: install_locked_python_deps install_ipykernel

# Install from lock file (not created with explicit, point of discussion)
install_locked_python_deps:
	mamba env create --force --name {{env-name}} --file lock.yml

install_python_deps:
	mamba env create --force --name {{env-name}} --file environment.yml

# Requires environment to be activated!
update_lock:
	mamba env export > lock.yml

install_ipykernel:
	{{env-cmd}} python -m ipykernel install --user
