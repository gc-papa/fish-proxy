# fish-proxy

[![License](https://img.shields.io/github/license/sukkaw/zsh-proxy.svg?style=flat-square)](./LICENSE)

:nut_and_bolt: A Fish shell plugin to configure proxy for package managers and software.

Converted from the original [zsh-proxy](https://github.com/sukkaw/zsh-proxy) plugin.

## Installation

### Fisher

Install using [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install your-username/fish-proxy
```

### Manual Installation

1. Clone this repository:

```fish
git clone https://github.com/your-username/fish-proxy.git ~/.config/fish/plugins/fish-proxy
```

2. Add to your `~/.config/fish/config.fish`:

```fish
source ~/.config/fish/plugins/fish-proxy/fish-proxy.fish
```

---

Congratulations! Open a new terminal or run `source ~/.config/fish/config.fish`. If you see following lines, you have successfully installed `fish-proxy`:

```
----------------------------------------
You should run following command first:
$ init_proxy
----------------------------------------
```

## Usage

### `init_proxy`

The tip mentioned above will show up next time you open a new terminal if you haven't initialized the plugin with `init_proxy`.

After you run `init_proxy`, it is time to configure the plugin.

### `config_proxy`

Execute `config_proxy` to configure fish-proxy. Fill in socks5 & http proxy address in format `address:port` like `127.0.0.1:1080` & `127.0.0.1:8080`.

Default configuration of socks5 proxy is `127.0.0.1:1080`, and http proxy is `127.0.0.1:8080`. You can leave any of them blank during configuration to use their default configuration.

Currently `fish-proxy` doesn't support proxy with authentication.

### `proxy`

After you configure the `fish-proxy`, you are good to go. Try the following command to enable proxy for supported package managers & software:

```fish
proxy
```

The next time you open a new terminal, fish-proxy will automatically enable proxy for you.

### `noproxy`

If you want to disable proxy, you can run the following command:

```fish
noproxy
```

### `myip`

If you forget whether you have enabled proxy or not, it is fine to run `proxy` command directly, as `proxy` will reset all the proxy before enabling them. But the smarter way is to use the following command to check which IP you are using now:

```fish
myip
```

The check procedure will use `curl` and the IP data come from `ip.sb`.

## Uninstallation

### Fisher

```fish
fisher remove your-username/fish-proxy
```

### Manual

Remove the plugin directory and clean up configuration:

```fish
rm -rf ~/.config/fish/plugins/fish-proxy
rm -rf ~/.fish-proxy
```

## Supported

`fish-proxy` currently supports these package managers & software:

- `http_proxy`
- `https_proxy`
- `ftp_proxy`
- `rsync_proxy`
- `all_proxy`
- git (http)
- npm, yarn & pnpm
- apt

## Differences from zsh-proxy

- Uses Fish shell syntax and conventions
- Configuration stored in `~/.fish-proxy/` (or `$XDG_CONFIG_HOME/.fish-proxy/`)
- Uses Fish's `set` command for environment variables
- Compatible with Fisher package manager

## Todo List

- socks5 & http proxy with authentication
- check whether the program exists before enabling proxy for it
- proxy for sudo user (`env_keep` or similar)
- proxy for:
  - yum
  - pip
  - gradle
  - git with ssh
  - gem
- `no_proxy` config improvements

## Credits

Original [zsh-proxy](https://github.com/sukkaw/zsh-proxy) by [Sukka](https://github.com/SukkaW).

## License

MIT License - see [LICENSE](./LICENSE) file for details.
