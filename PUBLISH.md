# Publication Instructions for fish-proxy

## Repository Setup

The fish-proxy repository is ready for publication on GitHub. Here's what has been prepared:

### Files Created/Modified:

1. **fish-proxy.fish** - Main plugin file (Fish shell conversion)
2. **conf.d/fish-proxy.fish** - Fisher configuration and event handlers
3. **README.md** - Updated main documentation
4. **LICENSE** - Updated to include both Sukka (original) and gc-papa (Fish conversion)
5. **package.json** - Package configuration for potential npm publication
6. **.gitignore** - Git ignore file
7. **INSTALL.md** - Installation instructions
8. **EXAMPLE.md** - Usage examples
9. **README-fish.md** - Additional Fish-specific documentation
10. **fisher_plugins** - Fisher plugin configuration

### Credits Maintained:

- Original zsh-proxy by Sukka is properly credited throughout
- License maintains copyright for both original and conversion
- README includes acknowledgments section
- Headers in code files reference original author

## Next Steps for Publication:

### 1. Create GitHub Repository

Go to https://github.com/gc-papa and create a new repository named "fish-proxy"

### 2. Push to GitHub

```bash
cd /home/gpx/Code/zsh-proxy
git branch -M main
git push -u origin main
```

### 3. Create Release

1. Go to GitHub repository
2. Click "Releases" → "Create a new release"
3. Tag version: `v1.0.0`
4. Release title: `fish-proxy v1.0.0 - Fish Shell Proxy Plugin`
5. Description:

````markdown
🐟 First release of fish-proxy - A Fish shell proxy management plugin

This is a Fish shell conversion of the excellent [zsh-proxy](https://github.com/sukkaw/zsh-proxy) plugin by [Sukka](https://github.com/SukkaW).

## Features

- Easy proxy configuration with interactive setup
- Support for HTTP, HTTPS, SOCKS5, and SOCKS5h proxies
- Automatic proxy configuration for Git, NPM, Yarn, PNPM, APT
- Fisher package manager compatibility
- Native Fish shell syntax and conventions

## Installation

```fish
fisher install gc-papa/fish-proxy
```
````

## Credits

Special thanks to [Sukka](https://github.com/SukkaW) for the original zsh-proxy plugin.

````

### 4. Test Installation

After publishing, test the Fisher installation:

```fish
fisher install gc-papa/fish-proxy
````

### 5. Optional: Add to Fish Plugin Lists

Consider submitting to:

- [Awesome Fish](https://github.com/jorgebucaran/awesome-fish)
- [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish)

## Troubleshooting

### Issue: `init_proxy` command not found

If after installing with Fisher the `init_proxy` command is not found, this is likely because Fisher needs individual function files to properly load commands.

**Solution**: The plugin now includes individual function files in the `functions/` directory:
- `functions/init_proxy.fish`
- `functions/config_proxy.fish`
- `functions/proxy.fish`
- `functions/noproxy.fish`
- `functions/myip.fish`
- `functions/fish_proxy_update.fish`

**For users experiencing this issue:**

1. **Reinstall the plugin:**
   ```fish
   fisher remove gc-papa/fish-proxy
   fisher install gc-papa/fish-proxy
   ```

2. **Or reload your shell:**
   ```fish
   exec fish
   ```

3. **Or manually source the configuration:**
   ```fish
   source ~/.config/fish/conf.d/fish-proxy.fish
   ```

### Testing Installation

After installation, test that all functions are available:

```fish
functions | grep -E '(init_proxy|config_proxy|proxy|noproxy|myip)'
```

You should see all five functions listed.

## Repository Structure:

```
fish-proxy/
├── fish-proxy.fish          # Main plugin file
├── functions/               # Individual function files (for Fisher)
│   ├── init_proxy.fish
│   ├── config_proxy.fish
│   ├── proxy.fish
│   ├── noproxy.fish
│   ├── myip.fish
│   └── fish_proxy_update.fish
├── conf.d/
│   └── fish-proxy.fish     # Fisher configuration and auto-loader
├── README.md               # Main documentation
├── LICENSE                 # MIT License (dual copyright)
├── package.json            # Package configuration
├── .gitignore             # Git ignore rules
├── INSTALL.md             # Installation guide
├── EXAMPLE.md             # Usage examples
├── README-fish.md         # Fish-specific docs
└── fisher_plugins         # Fisher plugin list
```

The repository is now ready for publication with proper attribution to the original author and full Fish shell compatibility!
