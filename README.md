# Docker image for [Tweakstreet](https://tweakstreet.io)

The image contains the tweakstreet execution engine. It makes all Tweakstreet [CLI commands](https://docs.tweakstreet.io/docs/command-line/) available.

The image has an `/app` folder which is a convenient place to mount your data project. The CLI commands are in PATH, so you can invoke them by name.

## To run a flow

To run `/my/project/main.cfl` using [engine.sh](https://docs.tweakstreet.io/docs/command-line/running-flows/index.html)

```bash
docker run --init --rm \
  -v /my/project:/app twineworks/tweakstreet \
  engine.sh /app/main.cfl
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

