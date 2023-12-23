# NVM Commands

## check version
```bash
node -v || node --version
```

##  list locally installed versions of node
```bash
nvm ls
```

## list remove available versions of node
```bash
nvm ls-remote
```

## install specific version of node
```bash
nvm install 18.16.1
```

## set default version of node
```bash
nvm alias default 18.16.1
```

## switch version of node
```bash
nvm use 20.5.1
```

## install latest LTS version of node (Long Term Support)
```bash
nvm install --lts
```

## install latest stable version of node
```bash
nvm install stable
```