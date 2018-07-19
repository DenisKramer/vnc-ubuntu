# --- Container assembly ---
FROM ubuntu:18.10

# --- Install X11, vnc, wm, ... ---
RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install keyboard-configuration && \
    apt-get -yq install supervisor curl vim xinit slim openbox rxvt fonts-noto x11-xserver-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -L -o tigervnc-1.9.0.x86_64.tar.gz https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.9.0.x86_64.tar.gz && \
    tar xvzf tigervnc-1.9.0.x86_64.tar.gz -C / --strip-components=1

# --- Add screen resolutions for xrandr
RUN curl -L -o /sbin/add-vnc-mode https://raw.githubusercontent.com/ebertland/home-bin/master/add-vnc-mode && \
    chmod a+x /sbin/add-vnc-mode

# --- Configure supervisord ---
COPY assets/supervisor.conf /etc/supervisord.conf
RUN mkdir /var/run/dbus
RUN curl https://bootstrap.pypa.io/ez_setup.py | python

# --- Slim Login Manager ---
COPY assets/slim/slim.conf /etc/slim.conf
COPY assets/slim/alpinelinux /usr/share/slim/themes/alpinelinux

# --- Configure X11 ---
COPY assets/xorg.conf /etc/X11/xorg.conf

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
COPY assets/urxvt/perl /usr/lib/urxvt/perl
COPY assets/Xresources /etc/X11/Xresources

COPY assets/xinit/xinitrc.d/* /etc/X11/xinit/xinitrc.d/
RUN chmod a+x /etc/X11/xinit/xinitrc.d/*
COPY assets/xinit/xinitrc /etc/X11/xinit/xinitrc
RUN chmod a+x /etc/X11/xinit/xinitrc

# Ensure prompt is configured correctly in bash (/etc/bashrc.bash overwrites the xinit value)
COPY assets/xinit/xinitrc.d/00-terminal-prompt /etc/profile.d/prompt.sh
COPY assets/bashrc /etc/bash.bashrc

COPY assets/openbox/autostart /etc/xdg/openbox/autostart
RUN chmod a+x /etc/xdg/openbox/autostart

# --- Make sure home directory template folder exists
RUN mkdir -p /etc/home-template

# Copy start script
COPY assets/startx /sbin/startx
RUN chmod u+x /sbin/startx

EXPOSE 5900
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
