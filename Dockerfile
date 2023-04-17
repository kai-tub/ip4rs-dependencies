FROM --platform=linux/amd64 mambaorg/micromamba:1.4.2
COPY --chown=$MAMBA_USER:$MAMBA_USER lock.yml /tmp/lock.yml
RUN micromamba install --yes --name base --file /tmp/lock.yml && \
    micromamba clean --all --yes
ARG MAMBA_DOCKERFILE_ACTIVATE=1  # (otherwise python will not be found)

# guarantee trouble-some libraries are loaded correctly
RUN python -c "import rasterio; import geopandas; import torch; import numpy; print('\nCould load libraries!\n');"

ENTRYPOINT [ "/usr/local/bin/_entrypoint.sh", "jupyter", "lab", "--no-browser", "--ServerApp.trust_xheaders=True", "--ServerApp.disable_check_xsrf=False", "--ServerApp.allow_remote_access=True", "--ServerApp.allow_origin='*'"]
# ENTRYPOINT [ "/usr/local/bin/_entrypoint.sh", "jupyter", "lab", "--ip", "0.0.0.0"]