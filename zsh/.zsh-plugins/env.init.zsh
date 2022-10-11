export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 

export UPLUGINS=$HOME/.zsh-plugins
export DOCKER_BUILDKIT=1
export GOPATH=$(go env GOPATH)
export GOROOT=$(go env GOROOT)
export GPG_TTY=$(tty)
export EDITOR=nvim
# Enable colored output in ls
export CLICOLOR=1
