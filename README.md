# miniflux-setup

Script and configurations to spin up Miniflux


## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Install](#install)
- [License](#license)


## Features

- Miniflux server
- Nginx config


## Requirements

| Dependencies | Purpose |
|:---|:---|
| [`dotfiles-system`][dotfiles-system] | Provides utility functions |
| [`www-config`][www-config] | Provides base Nginx config |


## Install

The setup process will:

- Clone [`dotfiles-system`][dotfiles-system] in
`$HOME/projects/dotfiles-system`
- Create user: `miniflux`
- Harden `/var/lib/pgsql/`
- Set up a postgres database: `miniflux`
- Install [Miniflux][miniflux]
- Symlink [`read.tug.ro.conf`](read.tug.ro.conf) to
`/etc/nginx/conf.d/read.tug.ro.conf`
- Symlink [`miniflux.service`](miniflux.service) to
`/lib/systemd/system/miniflux.service`
- Reload Miniflux and Nginx

```bash
# Create projects directory and go inside
mkdir -p $HOME/projects && cd $HOME/projects

# Clone this repo
git clone https://github.com/musq/miniflux-setup.git

# Go inside
cd miniflux-setup

# Run installer
./setup.sh
```


## License

The code is available under [GNU AGPL v3, or later](LICENSE) license.


<!-- Link labels: -->

[dotfiles-system]: https://github.com/musq/dotfiles-system
[miniflux]: https://miniflux.app/
[www-config]: https://github.com/musq/www-config
