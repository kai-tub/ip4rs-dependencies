# IP4RS Dependencies

Dependencies for the IP4RS course.
The repository uses `micromamba` under the hood and provides some automations via a `justfile`.
The repository used to distributes the environment as a `Docker Image` but we are moving away from it as it provides little benefit over the
'direct' installation.
Previously, the main reason was to have an environment that could be loaded by paperspace.com and provide free GPUs but we had issues getting
free GPUs, or any free environments, and have moved away from it.
In the current course, we will try our best to remove the need for a GPU.

To update the dependencies, add the new libraries to the [environment.yml](./environment.yml) file and run `just update_lock`.

## Deprecated
The `Dockerfile` creates the environment defined in the [lock.yml](./lock.yml) file to ensure that the same libraries are used over the entire course.
