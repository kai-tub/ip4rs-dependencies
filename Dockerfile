FROM jupyter/base-notebook
ARG conda_env=ip4rs
EXPOSE 8888
# these are used in ENTRYPOINT `start-notebook.sh` script
ENV NOTEBOOK_ARGS="--no-browser --ip=0.0.0.0 --LabApp.trust_xheaders=True --LabApp.disable_check_xsrf=False --LabApp.allow_remote_access=True --LabApp.allow_origin='*'"

COPY --chown=${NB_UID}:${NB_GID} lock.yml "/home/${NB_USER}/tmp/"
RUN cd "/home/${NB_USER}/tmp/" && \
    mamba env create -p "${CONDA_DIR}/envs/${conda_env}" -f lock.yml && \
    mamba clean --all -f -y

# create Python kernel and link it to jupyter
RUN "${CONDA_DIR}/envs/${conda_env}/bin/python" -m ipykernel install --user --name="${conda_env}" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# any additional pip installs can be added by uncommenting the following line
# RUN "${CONDA_DIR}/envs/${conda_env}/bin/pip" install --quiet --no-cache-dir

# if you want this environment to be the default one, uncomment the following line:
RUN echo "conda activate ${conda_env}" >> "${HOME}/.bashrc"
