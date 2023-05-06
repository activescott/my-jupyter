# Snowflake Notebooks

This is a project containing everything needed to run python notebooks against snowflake. It has two many components:

1. Docker-based Jupyter environment for doing analysis. It uses [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html) in docker containers via pure docker-compose locally, or via [Dev Containers](https://containers.dev/) locally using the [VSCode Dev Containers Extention](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) or (in theory but not yet tested) works in Github Codespaces (since it appears to use Dev Containers spec). This is all under `.devcontainer/`. See Usage below for how to use it (TLDR; use scripts in `.devcontainer/host-scripts/` or use VSCode Dev Containers or Code Spaces extensions).
2. The python Snowman Package in `snowman-python-lib/` is a way to make it easy to use snowflake from notebooks. It is installed into the Jupyter stack by default when it's built.

## Usage

### .env & snowflake key pair

Put your environment variables in the `/.env` file to setup snowflake and setup your key pair as described in [`snowflake-key-pair/README.md`](snowflake-key-pair/README.md)

Depending on your preference for running containers choose one of the three _Jupyter in_ options below:

### Jupyter in Plain Docker Compose:

Run the following lines to build the container image and start the container:

```sh
./.devcontainer/host-scripts/docker-build.sh
./.devcontainer/host-scripts/docker-start.sh
```

Then after the container builds and starts up you should see it print out a URL to access the jupyter notebook in your browser something like **devcontainer-notebooks-1 | or http://127.0.0.1:8888/lab?token=decafbad**. Note the _token=_ query param which is needed to establish a session w/ Jupyter.

To stop the container run:

```sh
./.devcontainer/host-scripts/docker-stop.sh
```

### Jupyter in Local VSCode Dev Containers

Use the VSCode Command Pallet (CMD+SHIFT+P) and select **Dev Containers: Rebuild and Reopen in Container**

### Jupyter in Github CodeSpaces

Open the repo at github and use the UI there or use the VSCode Code Spaces extension and Github will host the docker containers in the cloud for you.

### Useful Commands When Running Locally via Docker Compose or Local Dev Container

```sh
# Build the image w/ compose config:
./.devcontainer/host-scripts/docker-build.sh

# rebuild container and ignore the docker image cache:
./.devcontainer/host-scripts/docker-rebuild.sh

# build container and setup the dev container config:
./.devcontainer/host-scripts/devcontainer-build.sh
```

## Snowman Python Library

See [snowman-python-lib/README.md](snowman-python-lib/README.md)

## TODO

See [TODO.md](TODO.md)
