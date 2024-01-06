FROM ubuntu:22.04

WORKDIR /root

# Install dependencies
RUN apt-get -y update && \
    NEEDRESTART_MODE=a apt-get -y upgrade && \
    apt-get install -y pkg-config build-essential libudev-dev libssl-dev curl git zsh

# Install fancy shell
RUN chsh -s /bin/zsh

RUN CHSH=no sh -c "$(curl -fsSL https://raw.github.com/beeman/server-shell/master/tools/install.sh)"

CMD ["zsh"]

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install the Solana release
RUN sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"

# Generate a default keypair in ~/.config/solana.id.json
RUN solana-keygen new --no-bip39-passphrase

# Install the SPL Token CLI
RUN cargo install spl-token-cli

# Install Node and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN corepack enable && \
    corepack prepare pnpm@8 --activate && \
    corepack prepare yarn@1 --activate

## Install Anchor
RUN cargo install --git https://github.com/coral-xyz/anchor avm --locked --force
RUN avm install latest && avm use latest

RUN git config --global user.email "dev@example.com" && git config --global user.name "dev" && git config --global init.defaultBranch main

