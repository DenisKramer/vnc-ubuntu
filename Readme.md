# vnc-ubuntu

This container provides a [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing)-enabled container based on [Ubuntu](https://www.ubuntu.com/).

The container is meant to serve a basis for containerised X11 applications. It has the following features:

- Openbox minimal Window Manager
- Graphical login (not configured by default)

## Usage

The container runs a VNC server on port 5900. This port has to be mapped for VNC clients to access it:

```bash
docker run -d -p 5900:5900 kramergroup/vnc-ubuntu
```

Once the container is running, point a VNC viewer to `localhost:5900`.

### Environment variables

The behaviour of the container can be controlled through a number of environment variables.

| Name     | Default  | Description                                           |
|:---------|:---------|:------------------------------------------------------|
| GEOMETRY | 1600x900 | Display dimensions                                    |
| RFBPORT  | 5900     | The VNC server port                                   |
| USERNAME | root     | The default user username (will be created if needed) |
| USERID   | auto     | The UID of the default user                           |

## Graphical User login (optional)

A connecting VNC client will be presented with a login window for the first time only.  **Note that terminating the VNC connection is not sufficient to logout the user!** There is no default user configured.

### Adding Users

The usual `useradd/passwd` feature of linux is available. To add a user to a running container with name `vnc-alpine` use:

```bash
  docker exec -it vnc-ubuntu adduser <username>
```

## Openbox Window Manager

The container uses the [Openbox](https://en.wikipedia.org/wiki/Openbox) window manager.
Openbox is lightweight and easy to configure (via xml files). Programs are started using a right-click, which produces a menu with options.

## Terminal

The container uses urxvt with a small number of extensions pre-installed. [Awesome urxvt](https://github.com/bookercodes/awesome-urxvt) has a curated list of other useful extensions.
