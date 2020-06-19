# Docker image for [Tweakstreet](https://tweakstreet.io)

The image contains the tweakstreet execution engine. It makes all Tweakstreet [CLI commands](https://docs.tweakstreet.io/docs/command-line/) available.

The image has an `/app` folder which is a convenient place to mount your project files.

## To run a flow

The following runs `/my/project/main.dfl` using [engine.sh](https://docs.tweakstreet.io/docs/command-line/running-flows/index.html), outputs the logs and removes the resulting container after finishing.

```bash
$  docker run --init --rm \
    -v /my/project:/app twineworks/tweakstreet \
    engine.sh /app/main.dfl

2020-06-19 18:28:04 Z | INFO  | main          | tweakstreet 1.0.2 on OpenJDK 64-Bit Server VM 11.0.7+10 (AdoptOpenJDK)
2020-06-19 18:28:04 Z | INFO  | main          | loading flow /app/main.dfl
2020-06-19 18:28:04 Z | INFO  | main.dfl      | initializing flow
...
2020-06-19 18:28:06 Z | INFO  | drop keys     | FINISHED total: {"in":  11323, "out":  11323, "error":      0}
2020-06-19 18:28:06 Z | INFO  | write records | FINISHED total: {"in":  11323, "out":  11323, "error":      0}
2020-06-19 18:28:06 Z | INFO  | main.dfl      | flow finished successfully
2020-06-19 18:28:06 Z | INFO  | main          | /app/main.dfl finished in 00:00:02
```

## To run a flow in the background


If you wish to run a long-running job in the background use the `-d` and `--name` docker switches:

```bash
$ docker run --init -d --name long_job \
    -v /my/project:/app twineworks/tweakstreet \
    engine.sh /app/main.dfl
```

Docker will run the container in the background. You can output the logs of your container using `docker logs` or follow them with `docker logs -f `:

```bash
$ docker logs long_job

2020-06-19 18:28:04 Z | INFO  | main          | tweakstreet 1.0.2 on OpenJDK 64-Bit Server VM 11.0.7+10 (AdoptOpenJDK)
2020-06-19 18:28:04 Z | INFO  | main          | loading flow /app/main.dfl
2020-06-19 18:28:04 Z | INFO  | main.dfl      | initializing flow
...
2020-06-19 18:28:06 Z | INFO  | drop keys     | FINISHED total: {"in":  11323, "out":  11323, "error":      0}
2020-06-19 18:28:06 Z | INFO  | write records | FINISHED total: {"in":  11323, "out":  11323, "error":      0}
2020-06-19 18:28:06 Z | INFO  | main.dfl      | flow finished successfully
2020-06-19 18:28:06 Z | INFO  | main          | /app/date_dimension.dfl finished in 00:00:02
```

Don't forget to remove the container once it is no longer needed to free up disk space.

```bash
$ docker rm long_job
```

## Tweakstreet HOME

The image contains a `/home/tweakstreet` folder. Mount a folder or volume at `/home/tweakstreet/.tweakstreet` if you need to provide [drivers or plugins](https://docs.tweakstreet.io/docs/getting-started/configuration/index.html).

```bash
docker run --init --rm \
  -v /my/.tweakstreet:/home/tweakstreet/.tweakstreet:ro \
  -v /my/project:/app twineworks/tweakstreet \
  engine.sh /app/main.cfl
```

## Container Details

Commands run as user `tweakstreet` in main group `tweakstreet` with `uid:gid`  set to `1001:1001`.

The tweakstreet binaries are in `/opt/tweakstreet/bin`.

