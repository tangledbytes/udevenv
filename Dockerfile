# Generate custom
FROM kindest/base:v20220922-155e503a

# Pre ##########################################################################
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS
ARG GOVERSION=go1.19.2

RUN mkdir /kind

# Copy the essentials
COPY ./zsh /setup/zsh

# Debug messsage
RUN echo "Building for OS: ${TARGETOS} ARCH: ${TARGETARCH}"

# Setup core tool ###############################################################
RUN apt update
RUN apt install -y build-essential libssl-dev ca-certificates pkg-config locales
RUN apt install -y git curl wget unzip sudo vim automake autoconf autotools-dev \
    zsh software-properties-common neovim

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

# Setup development tools ########################################################
WORKDIR /setup

# Setup Golang from go.dev in the container
RUN rm -rf /usr/local/go
RUN wget https://go.dev/dl/${GOVERSION}.linux-${TARGETARCH}.tar.gz 
RUN sudo tar -C /usr/local -xzf ${GOVERSION}.linux-${TARGETARCH}.tar.gz
ENV PATH /usr/local/go/bin:$PATH
RUN rm -rf ${GOVERSION}.linux-$TARGETARCH.tar.gz

# Install rust in the container
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install NVM in the container
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh

# Setup ZSH ######################################################################
## Install default ZSH Plugins
WORKDIR /setup/zsh-plugins

### ZSH Completions
RUN git clone --depth=1 https://github.com/zsh-users/zsh-completions.git
### ZSH VI Mode
RUN git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode.git
### ZSH Autosuggestions
RUN git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git
### ZSH Syntax Highlighting
RUN git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git
### ZSH History Substring Search
RUN git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git

# Setup Shell ####################################################################
# Install StarShip
RUN curl -sS https://starship.rs/install.sh | sudo sh -s -- --yes

# Clean up #######################################################################
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Finish ########################################################################
WORKDIR /root

COPY ./entrypoint.sh /setup/entrypoint.sh

RUN chmod +x /setup/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint", "/setup/entrypoint.sh" ]