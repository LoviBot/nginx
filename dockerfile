FROM archlinux

# Add mirrors for Sweden. You can add your own mirrors to the mirrorlist file. Should probably use reflector.
ADD mirrorlist /etc/pacman.d/mirrorlist

# NOTE: For Security Reasons, archlinux image strips the pacman lsign key.
# This is because the same key would be spread to all containers of the same
# image, allowing for malicious actors to inject packages (via, for example,
# a man-in-the-middle).
RUN gpg --refresh-keys && pacman-key --init && pacman-key --populate archlinux

# Set locale. Needed for some programs.
# https://wiki.archlinux.org/title/locale
RUN echo "en_US.UTF-8 UTF-8" >"/etc/locale.gen" && locale-gen && echo "LANG=en_US.UTF-8" >"/etc/locale.conf"

# Update the system and install qbittorent-nox and Python
# Python is needed for the torrent search tab
# https://archlinux.org/packages/community/x86_64/qbittorrent-nox/
# Modules can be found here: https://aur.archlinux.org/packages?O=0&SeB=n&K=nginx-mainline&outdated=&SB=p&SO=a&PP=250&submit=Go
RUN pacman -Syu --noconfirm && pacman -S nginx-mainline --noconfirm

# Remove cache. TODO: add more cleanup. Should we remove pacman?
RUN rm -rf /var/cache/*

# Config files are stored in /etc/nginx/
# Logs are stored in /var/log/nginx
# Default location for documents is /usr/share/nginx/html
VOLUME ["/var/log/nginx", "/etc/nginx/", "/usr/share/nginx"]
WORKDIR /usr/share/nginx

# 80/tcp    HTTP
# 443/tcp   HTTPS
EXPOSE 80/tcp 443/tcp

CMD ["/usr/bin/nginx", "-g", "daemon off;"]