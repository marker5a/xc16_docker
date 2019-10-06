FROM archlinux/base

RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

RUN pacman -Sy gcc make git net-tools  pkg-config yajl awk diffutils fakeroot file gettext ucl upx lib32-glibc lib32-gcc-libs lib32-libxcb xtrans xorg-util-macros patch --noconfirm
RUN mkdir /home/yaourt_builder

RUN useradd yaourt_builder
RUN chown yaourt_builder /home/yaourt_builder
USER yaourt_builder
RUN gpg --recv-key 3BB639E56F861FA2E86505690FDD682D974CA72A

RUN cd /tmp && git clone https://aur.archlinux.org/yaourt && git clone https://aur.archlinux.org/package-query
RUN cd /tmp/package-query && makepkg
USER root
RUN pacman -U /tmp/package-query/*xz --noconfirm
USER yaourt_builder
RUN cd /tmp/yaourt && makepkg
USER root
RUN pacman -U /tmp/yaourt/*xz --noconfirm
USER yaourt_builder

RUN cd /tmp && yaourt -G lib32-libx11-threadsafe lib32-tclkit sdx microchip-mplabxc16-bin libx11-threadsafe 

USER yaourt_builder
RUN cd /tmp/libx11-threadsafe && makepkg
USER root
RUN pacman -U /tmp/libx11-threadsafe/*xz --noconfirm

USER yaourt_builder
RUN cd /tmp/lib32-libx11-threadsafe && makepkg
USER root
RUN pacman -U /tmp/lib32-libx11-threadsafe/*xz --noconfirm


USER yaourt_builder
RUN cd /tmp/lib32-tclkit && makepkg
USER root
RUN pacman -U /tmp/lib32-tclkit/*xz --noconfirm


USER yaourt_builder
RUN cd /tmp/sdx && makepkg
USER root
RUN pacman -U /tmp/sdx/*xz --noconfirm



USER yaourt_builder
RUN cd /tmp/microchip-mplabxc16-bin && makepkg
USER root
RUN pacman -U /tmp/microchip-mplabxc16-bin/*pkg.tar --noconfirm


RUN rm /tmp/* -rf
RUN yes | pacman -Scc
RUN userdel yaourt_builder

