# vnc-suse

This container provides a [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing)-enabled container based on [OpenSuse](https://www.opensuse.org/).

The container is meant to serve a basis for containerised X11 applications. It has the following features:

- Openbox minimal Window Manager
- Graphical login
- LDAP authentication (if configured)

Based on a 43MB [Suse container](https://hub.docker.com/_/opensuse/), the container is less than xxx MB in size. Most of this is the X11 window system.

## Usage

The container runs a VNC server on port 5900. This port has to be mapped for VNC clients to access it:

```bash
docker run -d -p 5900:5900 kramergroup/vnc-suse
```

Once the container is running, point a VNC viewer to `localhost:5900`.

## User login

A connecting VNC client will be presented with a login window for the first time only.  **Note that terminating the VNC connection is not sufficient to logout the user!** There is no default user configured.

### Adding Users

The usual `useradd/passwd` feature of linux is available. To add a user to a running container with name `vnc-alpine` use:

```bash
  docker exec -it vnc-suse adduser <username>
```

### Ldap support

The container is ldap-ready. To enable authentication against an LDAP server, provide a '''/etc/pam_ldap.conf''' file. The file format is described in the [pam man pages](https://linux.die.net/man/5/pam_ldap). An example is given below.

```
uri ldap://ldap.example.com
base dc=example,dc=com
logdir /var/log/ldap
pam_login_attribute sAMAccountName
```

## Openbox Window Manager

The container uses the [Openbox](https://en.wikipedia.org/wiki/Openbox) window manager.
Openbox is lightweight and easy to configure (via xml files). Programs are started using a right-click, which produces a menu with options.

## Terminal

The container uses urxvt with a small number of extensions pre-installed. [Awesome urxvt](https://github.com/bookercodes/awesome-urxvt) has a curated list of other useful extensions.
