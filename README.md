<div align="center">

![discord Logo](logo.svg)

# discord.nvim

![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/mistweaverco/discord.nvim?style=for-the-badge)](https://github.com/mistweaverco/discord.nvim/releases/latest)

[Requirements](#requirements) • [Install](#install) • [Usage](#usage)

<p></p>

An unobtrusive Discord <a href="https://discord.com/rich-presence">Rich Presence</a> plugin that just works.

<p></p>

</div>

## Requirements

> [!WARNING]
> Requires [Neovim 0.10.1+](https://neovim.io) and [NodeJS 20](https://nodejs.org)

NodeJS is required due to the usage of
the [official SDK](https://discord.com/developers/docs/developer-tools/embedded-app-sdk)

## Features

- Light and unobtrusive
- Written in Pure Lua and is [highly configurable](#configuration)
- Custom logo if desired.
- Great looking icons!

## Installation

Use your favorite plugin manager

- [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
{ 
    'mistweaverco/discord.nvim',
    event = "VeryLazy"
}
```

- [packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use 'mistweaverco/discord.nvim'
```

- [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'mistweaverco/discord.nvim'
```

## Configuration

Configuration is not necessary for Rich Presence to work.
But for those that want to override the default configs,
the following options are available to configure Lua.

### Lua

Require the plugin and call `setup` with a config table with one or more of the following keys:

```lua
-- The setup config table shows all available config options with their default values:
require("discord").setup({
    -- General options
    auto_connect        = false,                      -- Automatically connect to Discord RPC
    logo                = "auto",                     -- "auto" or url
    logo_tooltip        = nil,                        -- nil or string
    main_image          = "language",                 -- "language" or "logo"
    client_id           = "1233867420330889286",      -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    show_time           = true,                       -- Show the timer
    global_timer        = true,                       -- if set false, timer will be reset on aucmds

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
    terminal_text       = "Using Terminal",           -- Format string rendered when in terminal mode.
})
```
