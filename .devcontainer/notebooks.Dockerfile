# selecting an image: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-scipy-notebook
FROM jupyter/scipy-notebook:2023-05-01

# We want to run common-debian.sh from here:
# https://github.com/microsoft/vscode-dev-containers/tree/main/script-library#development-container-scripts
# But that script assumes that the main non-root user (in this case jovyan)
# is in a group with the same name (in this case jovyan).  So we must first make that so.
COPY docker-scripts/common-debian.sh /tmp/docker-scripts/
USER root
RUN apt-get update \
 && groupadd jovyan \
 && usermod -g jovyan -a -G users jovyan \
 && bash /tmp/docker-scripts/common-debian.sh \
 && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
 && bash /tmp/docker-scripts/common-debian.sh

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
#COPY requirements.txt /tmp/pip-tmp/
#RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp \
#    && bash /tmp/docker-scripts/common-debian.sh

# Install Snowflake Connector:
ARG SNOWFLAKE_CONNECTOR_VERSION="v2.8.3"
ARG SNOWFLAKE_CONNECTOR_PYTHON_VERSION="310"
ARG SNOWFLAKE_CONNECTOR_REQUIREMENTS_FILENAME="snowflake-connector_${SNOWFLAKE_CONNECTOR_VERSION}_tested_requirements_${SNOWFLAKE_CONNECTOR_PYTHON_VERSION}.reqs"
# NOTE: This rather odd two-step approach to installing a python package is prescribed in their docs at https://docs.snowflake.com/en/user-guide/python-connector-install.html#label-python-connector-install-connector
## First install dependencies of the connector:
COPY docker-scripts/snowflake-connector-install/${SNOWFLAKE_CONNECTOR_REQUIREMENTS_FILENAME} /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/${SNOWFLAKE_CONNECTOR_REQUIREMENTS_FILENAME} \
    && rm -rf /tmp/pip-tmp \
    && bash /tmp/docker-scripts/common-debian.sh

## Next install the connector itself:
RUN pip3 --disable-pip-version-check --no-cache-dir install "snowflake-connector-python==$SNOWFLAKE_CONNECTOR_VERSION" \
    && rm -rf /tmp/pip-tmp \
    && bash /tmp/docker-scripts/common-debian.sh

# Install Snowman python lib:
ARG SNOWMAN_VERSION=0.0.4
COPY docker-scripts/snowman-python-lib-install/snowman-${SNOWMAN_VERSION}-py3-none-any.whl /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install /tmp/pip-tmp/snowman-${SNOWMAN_VERSION}-py3-none-any.whl \
    && rm -rf /tmp/pip-tmp \
    && bash /tmp/docker-scripts/common-debian.sh


# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

USER jovyan
