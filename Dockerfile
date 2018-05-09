# --- Container assembly ---
FROM opensuse:42.3

# --- Install X11, vnc, wm, ... ---
RUN echo 't' | zypper addrepo "http://download.opensuse.org/repositories/X11:/lxde/openSUSE_Leap_42.3/" X11:lxde && \
    echo 't' | zypper addrepo "http://download.opensuse.org/repositories/Cloud:/OpenStack:/Master/openSUSE_Leap_42.3/" Cloud:OpenStack:Master && \
    zypper -n --no-gpg-checks install nss-pam-ldapd python-supervisor xorg-x11-Xvnc dbus-1 slim openbox curl vim && \
    zypper -n clean --all
RUN mkdir /run/dbus

# --- Configure supervisord ---
COPY assets/supervisor.conf /etc/supervisord.conf
RUN curl https://bootstrap.pypa.io/ez_setup.py | python

# --- Configure security and authentication
COPY assets/auth/pam.d/* /etc/pam.d/
COPY assets/auth/nslcd.conf /etc/nslcd.conf
COPY assets/auth/nsswitch.conf /etc/nsswitch.conf
COPY assets/home-template /etc/home-template

# --- Configure X11 ---
COPY assets/xorg.conf /etc/X11/xorg.conf
COPY assets/syslog.conf /etc/syslog.conf

# --- Slim Login Manager ---
COPY assets/slim/slim.conf /etc/slim.conf
COPY assets/slim/alpinelinux /usr/share/slim/themes/alpinelinux

# --- Configure Openbox window manager ---
COPY assets/openbox/mayday/mayday-arc /usr/share/themes/mayday-arc
COPY assets/openbox/mayday/mayday-arc-dark /usr/share/themes/mayday-arc-dark
COPY assets/openbox/mayday/mayday-grey /usr/share/themes/mayday-grey
COPY assets/openbox/mayday/mayday-plane /usr/share/themes/mayday-plane
COPY assets/openbox/rc.xml /etc/xdg/openbox/rc.xml
COPY assets/openbox/menu.xml /etc/xdg/openbox/menu.xml

# -- Install and configuew LDAP authentication ---
# Provide ldap configuration file and uncomment to enable ldap=based login
# Check pam manual for file format
# COPY assets/auth/pam_ldap.conf /etc/pam_ldap.conf

# --- Install urxvt terminal ---
RUN zypper -n install rxvt-unicode urxvt-font-size
COPY assets/urxvt/perl /usr/lib/urxvt/perl
COPY assets/Xresources /etc/X11/Xresources

# --- Fonts etc. ---
RUN echo 't' | zypper addrepo http://download.opensuse.org/repositories/M17N:/fonts/openSUSE_Leap_42.3/ M17N && \
    zypper -n --no-gpg-checks  install noto-sans-fonts noto-mono-fonts && \
    zypper clean --all

COPY assets/xinit/xinitrc.d/* /etc/X11/xinit/xinitrc.d/
COPY assets/xinit/xinitrc.d/00-terminal-prompt /etc/bash.bashrc.local

EXPOSE 5900
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
