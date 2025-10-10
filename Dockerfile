From fbe-dockerreg.rwu.de/doz-iki/staehle-vls/amr-tb3:latest

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
RUN rm -rf /opt/nvim-linux-x86_64
RUN tar -C /opt -xzf nvim-linux-x86_64.tar.gz
ENV PATH="/opt/nvim-linux-x86_64/bin:$PATH"

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get install -y nodejs
RUN npm install -g npm@latest



RUN curl -LO https://go.dev/dl/go1.25.2.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.25.2.linux-amd64.tar.gz
ENV PATH="$PATH:/usr/local/go/bin"

RUN apt install  unzip -y


RUN curl -sS https://starship.rs/install.sh  | sh -s -- --yes

RUN apt install exa -y

RUN apt install  wl-clipboard


# Addd  user
RUN apt install sudo -y
RUN groupadd -g 1000 niklas
RUN useradd  -u 1000 -g niklas  -g niklas -d /home/niklas/ -s /bin/bash niklas
# No password for user
RUN echo "niklas ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/niklas
USER niklas
WORKDIR /home/niklas

# Create directories
RUN mkdir -p /home/niklas/.config
RUN mkdir -p /home/niklas/ros2_ws/src

# Copy Config in container
COPY --chown=niklas:niklas .config /home/niklas/.config/
COPY --chown=niklas:niklas .bashrc /home/niklas/
