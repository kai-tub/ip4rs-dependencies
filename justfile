
# allow docker image to overwrite the environment
env-name := env_var_or_default("MAMBA_ENV_NAME", "ip4rs")

env-cmd := "mamba run --no-banner --name " + env-name
set dotenv-load := false

# Install environment from lock.yml
install: install_locked_python_deps install_ipykernel

# Install from lock file (not created with explicit!)
install_locked_python_deps:
	mamba env create --force --name {{env-name}} --file lock.yml

# Install from general environment.yml
install_python_deps:
	mamba env create --force --name {{env-name}} --file environment.yml

# Install dependencies from environment.yml and export to lock.yml
update_lock: install_python_deps
	{{env-cmd}} mamba env export > lock.yml

# Install the IPython Kernel for the new environment
install_ipykernel:
	{{env-cmd}} python -m ipykernel install --user
