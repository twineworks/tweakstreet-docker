# Docker image for [Tweakstreet](https://tweakstreet.io)

The image contains the tweakstreet execution engine. It makes all Tweakstreet [CLI commands](https://docs.tweakstreet.io/docs/command-line/) available on `PATH`.

The image has an `/app` folder which is a convenient place to mount your project files.

## Running a flow

The following runs `/my/project/main.dfl` using [engine.sh](https://docs.tweakstreet.io/docs/command-line/running-flows/index.html), outputs the logs and removes the resulting container when done.

```bash
$  docker run --init --rm \
     -v /my/project:/app \
     twineworks/tweakstreet \
     engine.sh /app/main.dfl

2020-06-19 18:28:04 Z | INFO  | main          | loading flow /app/main.dfl
2020-06-19 18:28:04 Z | INFO  | main.dfl      | initializing flow
...
2020-06-19 18:28:06 Z | INFO  | write records | FINISHED total: {"in": 123, "out": 123, "error": 0}
2020-06-19 18:28:06 Z | INFO  | main.dfl      | flow finished successfully
```

## Running a flow in the background


If you wish to run a long-running job in the background use the `-d` and `--name` docker switches:

```bash
$ docker run --init -d \
    --name long_job \
    -v /my/project:/app \
    twineworks/tweakstreet \
    engine.sh /app/main.dfl
```

Docker will run the container in the background. You can output the logs of your container using `docker logs` or follow them with `docker logs -f `:

```bash
$ docker logs long_job

2020-06-19 18:28:04 Z | INFO  | main          | loading flow /app/main.dfl
2020-06-19 18:28:04 Z | INFO  | main.dfl      | initializing flow
...
2020-06-19 18:28:06 Z | INFO  | write records | FINISHED total: {"in": 123, "out": 123, "error": 0}
2020-06-19 18:28:06 Z | INFO  | main.dfl      | flow finished successfully
```

Don't forget to remove the container once it is no longer needed to free up disk space.

```bash
$ docker rm long_job
```

## Tweakstreet HOME

The image contains a `/home/tweakstreet` folder. Mount a folder or volume at `/home/tweakstreet/.tweakstreet` if you need to provide [drivers or plugins](https://docs.tweakstreet.io/docs/getting-started/configuration/index.html).

```bash
$ docker run --init --rm \
    -v /my/.tweakstreet:/home/tweakstreet/.tweakstreet:ro \
    -v /my/project:/app \
    twineworks/tweakstreet \
    engine.sh /app/main.dfl
```

## Container Details

Commands run as user `tweakstreet` in main group `tweakstreet` with `uid:gid`  set to `1001:1001`.

The tweakstreet binaries are in `/opt/tweakstreet/bin`

