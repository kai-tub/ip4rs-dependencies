# IP4RS Dependencies

Dependencies for the IP4RS course.
Uses `mamba` under the hood and distributes it as a `Docker Image`.
To update the dependencies, add the new libraries to the [environment.yml](./environment.yml) file and run `just update_lock`.
The `Dockerfile` creates the environment defined in the [lock.yml](./lock.yml) file to ensure that the same libraries are used over the entire course.
