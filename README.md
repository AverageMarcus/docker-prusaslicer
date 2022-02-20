# docker-prusaslicer

Docker image containing PrusaSlicer, accessible via web UI or VNC.

## Features

* PrusaSlicer v2.4.0
* Web based GUI (Port 5800)
* VNC based access (Port 5900)
* Large selection of printer profiles
* Auto convert `.sl1` files to `.cbt` using [uv3dp](https://github.com/ezrec/uv3dp) - files in `/hom/resin` are watched and automatically converted. (Disable by setting the environment variable `AUTO_CONVERT_SL1=false`)

## Building from source

```sh
make docker-build
```

## Resources

* [docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui)
* [PrusaSlicer](https://github.com/prusa3d/PrusaSlicer)
* [uv3dp](https://github.com/ezrec/uv3dp)

## Contributing

If you find a bug or have an idea for a new feature please [raise an issue](issues/new) to discuss it.

Pull requests are welcomed but please try and follow similar code style as the rest of the project and ensure all tests and code checkers are passing.

Thank you 💛

## License

See [LICENSE](LICENSE)
