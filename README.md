# indocker-dev-node-react
Ready to use debian sid docker container for react/node applications development with neovim

### Usage
You can run this image with docker command
```
alias jsdev='docker run -it --rm \
    --name debian.js \
    -h debian.js \
    -v "$(pwd):/home/app/devel" \
    -p 127.0.0.1:3000:3000/tcp \
    -p 127.0.0.1:3080:3080/tcp \
    -u app \
    -w /home/app/devel \
    -e GIT_COMMITTER_NAME="author" \
    -e GIT_AUTHOR_NAME="author" \
    -e EMAIL=author@debian.js \
    apaskal/javascript-neovim:latest bash'

jsdev
```
Or alternativеly  

### Build and run  
Clone
```
git clone https://github.com/app/indocker-dev-node-react.git
```
Create directory for you projects
```
mkdir devel
```
Build and run docker container (takes some time)
```
cd indocker-dev-node-react
docker-compose up -d
```
Open shell inside docker
```
docker exec -it -u app debian-sid bash
```
You are ready for development with git, nvim, node, npm, yarn, ag, jq commands available  
Look at https://github.com/app/nvim to see neovim settings, plugins and key bindings  
