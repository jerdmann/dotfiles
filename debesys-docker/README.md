# debesys-docker
Simple docker container for building and running (at least some of the) debesys software.  The
intent is that this container is basically a compatibility layer between the host and the OS
requirements for debesys stuff.

## Building
First, you must create an `authorized_keys` file that contains the ssh public-key you will use to
authenticate against the running container.

Next, you must pass a user and userid to the container build.  These are used to create the
container user and keep file permissions seamless between the container environment and the host OS
one.
```shell
> docker build --network=host --tag debesys:latest --build-arg user=$(id -un) --build-arg userid=$(id -u) .
```

## Running
Create a new container instance by doing a `run` command.  Specify a container name so you can
easily start it back up again later.  Also, change the debesys repo path below to whatever actually
exists on your host machine.
```shell
> docker run -it --network=host --name=some_name --detach \
    --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
    --mount src=/home/jason/dev-root,target=/home/jason/dev-root,type=bind \
    --mount src=/etc/debesys,target=/etc/debesys,type=bind \
    debesys:latest
```
The cryptic `cap-add` line is to allow programs like `gdb` and `strace` to work correctly within the
container.

From this point forward, you can use the container by ssh'ing to it like:
```shell
> ssh some_user@localhost
```

On restarts, you can fire up the container again by simply doing:
```shell
> docker start some_name
```

## Workflow
The idea is that your repo is shared between the host OS and the container thanks to the bind mount
volume'd into the docker image.  You can edit locally and compile/test via the contianer.  If you
use a command-line-centric workflow, you can do everything via the image.

## TODO
* arg'ify the ssh port
