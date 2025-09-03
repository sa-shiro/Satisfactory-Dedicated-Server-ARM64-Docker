# Use Ubuntu 22.04 as base
FROM ubuntu:22.04

# Install cURL, Python 3, sudo, unbuffer and the package for "add-apt-repository"
RUN apt update && apt install -y curl python3 sudo expect-dev software-properties-common

# Fex build dependencies
RUN apt install -y squashfs-tools squashfuse git python-setuptools pkgconf clang
RUN apt install -y binfmt-support systemd cmake ninja-build software-properties-common
RUN apt install -y libncurses6 libncurses5 libtinfo5 libtinfo6 libncurses-dev
RUN apt install -y libsdl2-dev libepoxy-dev libssl-dev llvm lld
RUN apt install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5core5a libqt5gui5 libqt5widgets5 qtdeclarative5-dev qml-module-qtquick2 qml-module-qtquick-controls2 qml-module-qtquick-window2 nasm

# compiling FEX
RUN add-apt-repository -y ppa:fex-emu/fex
RUN git clone --recurse-submodules https://github.com/FEX-Emu/FEX.git
WORKDIR FEX 
RUN sed -i 's@USE_LEGACY_BINFMTMISC "Uses legacy method of setting up binfmt_misc" FALSE@USE_LEGACY_BINFMTMISC "Uses legacy method of setting up binfmt_misc" TRUE@' ./CMakeLists.txt
RUN mkdir Build
WORKDIR Build
RUN CC=clang CXX=clang++ cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DUSE_LINKER=lld -DENABLE_LTO=True -DBUILD_TESTS=False -DENABLE_ASSERTIONS=False -G Ninja ..
RUN ninja
RUN ninja install
RUN ninja binfmt_misc

# Create user steam
RUN useradd -m steam

# InstallL FEX root FS
RUN sudo -u steam bash -c "unbuffer FEXRootFSFetcher -y -x"

# Change user to steam
USER steam

# Go to /home/steam/Steam
WORKDIR /home/steam/Steam

# Download and extract SteamCMD
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Copy init-server.sh to container
COPY --chmod=755 --chown=steam:steam ./init-server.sh /home/steam/init-server.sh
RUN chmod +x /home/steam/init-server.sh

# Run it
ENTRYPOINT /home/steam/init-server.sh
