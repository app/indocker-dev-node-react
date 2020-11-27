# indocker-dev-node-react
Ready to use debian sid docker container for react/node applications development with neovim

### Usage
You can run this image with docker command
```
docker run --name js-vim --rm -t -i -v "$(pwd):/home/app/devel" \
-u app -w /home/app/devel apaskal/javascript-neovim:latest bash
```
Or

### Build and run (optional)
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
You are ready for development with git, vim, node, npm, ag commands available  
Look at https://github.com/app/nvim to see neovim settings, plugins and keybindings  
