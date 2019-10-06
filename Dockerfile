FROM archlinux/base

RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

RUN pacman -Sy gcc make git net-tools  pkg-config yajl awk diffutils fakeroot file gettext ucl upx lib32-glibc lib32-gcc-libs lib32-libxcb xtrans xorg-util-macros patch --noconfirm
RUN mkdir /home/yaourt_builder

RUN useradd yaourt_builder
RUN chown yaourt_builder /home/yaourt_builder
USER yaourt_builder
RUN gpg --recv-key 3BB639E56F861FA2E86505690FDD682D974CA72A

ARG packages="libx11-threadsafe lib32-libx11-threadsafe lib32-tclkit sdx microchip-mplabxc16-bin "

RUN cd /tmp && for name in $packages;do git clone https://aur.archlinux.org/$name;done

USER root
RUN for name in $packages; \
	do \
		cd /tmp/$name && \
		su  -c makepkg yaourt_builder && \
		pacman -U *.pkg.* --noconfirm; \
	done

RUN rm /tmp/* -rf
RUN yes | pacman -Scc
RUN userdel yaourt_builder

