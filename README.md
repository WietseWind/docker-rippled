# Rippled (node)

This container allows you to run a `rippled` node. No config required.

The server will keep a history of **only 256 ledgers**. You can change this value in the config (more about the config in this readme).

The container is configured to serve a public http websocket at port `80` and the local _rpc admin service_ in the container at port `5005`.
Other ports (443, 6006, 51235) can be mapped but should be enabled in the config first.

This container is running on `ubuntu:latest`.


## How to run

### From Github

If you downloaded / cloned the [Github repo](https://github.com/WietseWind/docker-rippled) you got yourself a few scripts to get started. In the `./go` folder, the following scripts are available, run:

- `go/build` to build the container image (tag: `rippled`)
- `go/up` to create a new container named `rippled` and setup the port and persistent config (*1)
- `go/down` to stop and remove the container `rippled`

The `go/up` command will mount the subfolder (in the cloned repo folder) `config` to the container; the `rippled.cfg` config and `validators.txt` will be loaded from this folder when `rippled` starts. If you stop/start or restart the container, the container will pickup your changes.

When starting the container the `go/up` script will map port `80` on your host to port `80` in the container. This is where `rippled` is configured to serve a websocket. If you want to run the websocket on another TCP port, you can enter the port after the `go/up` command, eg.:

```
go/up 8080
```

After spinning the container up, you will see the rippled log. You should see a lot of information show up within a few seconds. If you want to stop watching the log, press CTRL - C. The container will keep on running in the background.

If you want to build the image manually, use (you can change the tag):

```
docker build --tag rippled:latest .
```

### From the Docker Hub

Use the image `xrpllabsofficial/xrpld`.

**Because you only retrieved the container image from the Docker Hub, you have to manually create a container based on the image.** When creating the container, please make sure you open port `80`.

If you run the container with a mapping to `/config/` (in the container) containing a `rippled.cfg` and `validators.txt` file, these will be used. If the mapping or these files aren't present, `rippled` will start with the default config.

This command launches your `rippled` container and the rippled websocket at port `80`:

```
docker run -dit \
    --name rippled \
    -p 80:80 \
    -v /my/local/disk/xrpld-config/:/config/ \
    xrpllabsofficial/xrpld:latest
```

You can change the `--name` and **make sure you specify a valid local full path for your volume source, instead of `/my/local/disk/xrpld-config/`**.

You can fetch a working sample config from the [Github repo](https://github.com/WietseWind/docker-rippled).

### Note on Apple M1 / M2 chips:

Run the container with `--platform linux/amd64` to get it to work on your Mac M1 / M2.

### Passing arguments/environment variables

Both environment variables passed with `-e` to `docker run` and arguments added at the end of the `docker run` command will be passed. E.g.:

```bash
docker run \
  -e TESTVAR=123123 \
  -it --name rippled -p $PORT:80 \
  -v $(pwd)/../config:/config/ \
  xrpllabsofficial/xrpld:latest \
  -a \
  --start
```

... will pass the environment variable `TESTVAR` with value, and the arguments `-aaa` and `-c` to `rippled`.

Alternatively, if you can't pass direct arguments, you can pass a string of arguments as an environment variable called `ENV_ARGS`, like this:

```bash
docker run \
  -e ENV_ARGS="-a --start" \
  -it --name rippled -p $PORT:80 \
  -v $(pwd)/../config:/config/ \
  xrpllabsofficial/xrpld:latest
```

## So it's running

If you want to check the rippled-logs (container stdout, press CTRL - C to stop watching):

```
docker logs -f rippled
```

If you want to check the rippled server status:

```
docker exec rippled rippled server_info
```

Check the value of `complete_ledgers` in the server info to see if the server
has complete ledgers with transactions. When you launch the container it may take
a few minutes for the server to sync.

If you started the container manually, you may have to change the name of the container (`rippled`) to the name you entered in your `docker run` command.

## Connecting

You can now connect to the `rippled` websocket using a client like [xrpl.js](https://github.com/XRPLF/xrpl.js/tree/main).

# Updating

- **2018-02-21** rippled 0.90.0 [is released](https://ripple.com/dev-blog/rippled-version-0-90-0/)
- **2018-03-23** rippled 0.90.1 [is released](https://ripple.com/dev-blog/rippled-version-0-90-1/)
- **2018-05-15** rippled 1.0.0 [is released](https://twitter.com/nbougalis/status/996385729646297090)
- **2018-06-14** rippled 1.0.1 [is released](https://ripple.com/dev-blog/rippled-version-1-0-1/)
- **2018-09-15** rippled 1.1.0 [is released](https://github.com/ripple/rippled/releases/tag/1.1.0)
- **2018-10-23** rippled 1.1.1 [is released](https://ripple.com/dev-blog/rippled-version-1-1-1/)
- **2018-12-12** rippled 1.1.2 [is released](https://ripple.com/dev-blog/introducing-xrp-ledger-rippled-version-1-1-2/)
- **2019-02-14** rippled 1.2.0 [is released](https://github.com/ripple/rippled/releases/tag/1.2.0)
- **2019-02-27** rippled 1.2.1 [is released](https://github.com/ripple/rippled/releases/tag/1.2.1)
- **2019-03-07** rippled 1.2.2 [is released](https://github.com/ripple/rippled/releases/tag/1.2.2)
- **2019-04-03** rippled 1.2.3 [is released](https://github.com/ripple/rippled/releases/tag/1.2.3)
- **2019-04-17** rippled 1.2.4 [is released](https://github.com/ripple/rippled/releases/tag/1.2.4)
- **2019-07-26** rippled 1.3.1 [is released](https://xrpl.org/blog/2019/rippled-1.3.1.html)
- **2019-07-26** rippled 1.4.0 [is released](https://xrpl.org/blog/2019/rippled-1.4.0.html)
- **2020-04-01** rippled 1.5.0 [is released](https://xrpl.org/blog/2020/rippled-1.5.0.html)
- **2020-08-19** rippled 1.6.0 [is released](https://xrpl.org/blog/2020/rippled-1.6.0.html)
- **2021-02-24** rippled 1.7.0 [is released](https://xrpl.org/blog/2021/rippled-1.7.0.html)
- **2021-05-24** rippled 1.7.2 [is released](https://xrpl.org/blog/2021/rippled-1.7.2.html)
- **2021-08-28** rippled 1.7.3 [is released](https://xrpl.org/blog/2021/rippled-1.7.3.html)
- **2021-12-02** rippled 1.8.1 [is released](https://xrpl.org/blog/2021/rippled-1.8.1.html)
- **2022-01-14** rippled 1.8.4 [is released](https://xrpl.org/blog/2022/rippled-1.8.4.html)
- **2022-02-08** rippled 1.8.5 [is released](https://xrpl.org/blog/2022/rippled-1.8.5.html)
- **2022-04-07** rippled 1.9.0 [is released](https://xrpl.org/blog/2022/rippled-1.9.0.html)
- **2022** rippled 1.9.2 [is released](https://xrpl.org/blog/2022/rippled-1.9.2.html)
- **2022** rippled 1.9.3 [is released](https://xrpl.org/blog/2022/rippled-1.9.3.html)
- **2022** rippled 1.9.4 [is released](https://xrpl.org/blog/2022/rippled-1.9.4.html)
- **2023-03-14** rippled 1.10.0 [is released](https://xrpl.org/blog/2023/rippled-1.10.0.html)
- **2023-03** rippled 1.10.1 [is released](https://xrpl.org/blog/2023/rippled-1.10.0.html)
- **2023-06-27** rippled 1.11.0 [is released](https://xrpl.org/blog/2023/rippled-1.11.0.html)
- **2023-09-06** rippled 1.12.0 [is released](https://xrpl.org/blog/2023/rippled-1.12.0.html)
- **2024-01-09** rippled 2.0.0 [is released](https://xrpl.org/blog/2024/rippled-2.0.0.html)
- **2024-01-29** rippled 2.0.1 [is released](https://github.com/XRPLF/rippled/releases/tag/2.0.1)
- **2024-02-20** rippled 2.1.0 [is released](https://xrpl.org/blog/2024/rippled-2.1.0.html)
- **2024-03-27** rippled 2.1.1 [is released](https://xrpl.org/blog/2024/rippled-2.1.1)
- **2024-06-05** rippled 2.2.0 [is released](https://xrpl.org/blog/2024/rippled-2.2.0)
- **2024-07-31** rippled 2.2.1 [is released](https://xrpl.org/blog/2024/rippled-2.2.1)
- **2024-09-03** rippled 2.2.2 [is released](https://xrpl.org/blog/2024/rippled-2.2.2)
- **2024-09-18** rippled 2.2.3 [is released](https://xrpl.org/blog/2024/rippled-2.2.3)
- **2024-11-26** rippled 2.3.0 [is released](https://xrpl.org/blog/2024/rippled-2.3.0)
- **2025-01-30** rippled 2.3.1 [is released](https://github.com/XRPLF/rippled/releases/tag/2.3.1)
- **2025-03-07** rippled 2.4.0 [is released](https://xrpl.org/blog/2025/rippled-2.4.0)
- **2025-06-24** rippled 2.5.0 [is released](https://xrpl.org/blog/2025/rippled-2.5.0)
- **2025-08-27** rippled 2.6.0 [is released](https://xrpl.org/blog/2025/rippled-2.6.0)
- **2025-09-09** rippled 2.5.1 is released (Fix)
- **2025-10-01** rippled 2.6.1 [is released](https://github.com/XRPLF/rippled/releases/tag/2.6.1)
- **2025-11-20** rippled 2.6.2 [is released](https://github.com/XRPLF/rippled/releases/tag/2.6.2)
- **2025-12-09** rippled 3.0.0 [is released](https://github.com/XRPLF/rippled/releases/tag/3.0.0)
- **2026-01-28** rippled 3.1.0 [is released](https://github.com/XRPLF/rippled/releases/tag/3.1.0)

## Update process

1. Stop the container: `docker stop rippled` (if you named (`--name`) the container `rippled`)
2. Remove the container: `docker rm rippled`
3. Remove the image: `docker rmi xrpllabsofficial/xrpld:latest` (or if you built the container image based on the [Github repo](https://github.com/WietseWind/docker-rippled): use the image name you specified when building)
4. Re-create the container; if you used Git: `git pull` and `go/build` - if you used the Docker Hub: just use the command from this Readme (_From the Docker Hub_), a new version of the image will be downloaded.

**USE THE PATHS YOU SPECIFIED (`-v` argument) WHEN RECREATING THE CONTAINER IF YOU WANT TO KEEP YOUR CONFIG AND/OR DATA!**

## Building & publishing to Docker Hub:

```
version=3.1.0 # Sample
docker build --platform linux/amd64 --no-cache --tag xrpllabsofficial/xrpld:$version .
docker push xrpllabsofficial/xrpld:$version
docker tag xrpllabsofficial/xrpld:$version xrpllabsofficial/xrpld:latest
docker push xrpllabsofficial/xrpld:latest
```
