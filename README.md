# mise tool plugin for elp

This is a a mise tool plugin for [elp](https://whatsapp.github.io/erlang-language-platform/).

## Using this Plugin

### Install plugin
```bash
mise plugin install elp https://github.com/belltoy/mise-elp.git
```

> [!NOTE]
> This plugin will not be accepted into the mise official plugins repository
> [for supply-chain security reasons](https://mise.jdx.dev/registry.html#backends).
> So you need use the above command to install it from this repository.

### Install elp tool

```bash
## List available versions
mise ls-remote elp

## Install latest version
mise install elp

## Install OTP specific latest version aliases
mise install elp@otp-26
mise install elp@otp-27
mise install elp@otp-28

## Install specific version
mise install elp@otp-28-2025-11-04
```

> [!Tip]
> Since `elp` use date as release version for now, this plugin provides aliases for each supported
> OTP version for conveniently installing the latest `elp` for that OTP version.

Add `elp` to your `.mise.toml` for project-specific usage:

```toml
[tools]
elp = "otp-27"
```

In a new project, run:

```bash
mise install
```

to install all tools specified in `.mise.toml`, including `elp`.

To check the installed tools, run:

```bash
mise ls

mise which elp
```

## References

Refer to the mise docs for detailed information:

- [Tool plugin development](https://mise.jdx.dev/tool-plugin-development.html) - Complete guide to plugin development
- [Lua modules reference](https://mise.jdx.dev/plugin-lua-modules.html) - Available Lua modules and functions
- [Plugin publishing](https://mise.jdx.dev/plugin-publishing.html) - How to publish your plugin
- [mise-plugins organization](https://github.com/mise-plugins) - Community plugins repository

## License

MIT
